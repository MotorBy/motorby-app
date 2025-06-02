import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:mobile_auto_drive/models/PlacesSearchModel/place.dart';
import 'package:mobile_auto_drive/models/PlacesSearchModel/placeType.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

class SearchMapPlace extends StatefulWidget {
  SearchMapPlace({
    required this.apiKey,
    this.placeholder  ,
    this.icon = Icons.search,
    this.hasClearButton = true,
    this.clearIcon = Icons.clear,
    this.iconColor = Colors.blue,
    this.onSelected,
    this.onSearch,
    this.language = 'en',
    this.location,
    this.radius,
    this.strictBounds = false,
    this.placeType,
    this.isEnabled,
    this.darkMode = false,
    this.key,
  })  : assert((location == null && radius == null) || (location != null && radius != null)),
        super(key: key);

  final Key? key;
  final String apiKey;
  final String? placeholder;
  final void Function(Place place)? onSelected;
  final void Function(Place place)? onSearch;
  final String language;
  final LatLng? location;
  final int? radius;
  final bool strictBounds;
  final PlaceType? placeType;
  final IconData icon;
  final bool? isEnabled;
  final bool hasClearButton;
  final IconData clearIcon;
  final Color iconColor;

  final bool darkMode;

  @override
  _SearchMapPlaceState createState() {
    return _SearchMapPlaceState();
  }
}

class _SearchMapPlaceState extends State<SearchMapPlace> with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  late AnimationController _animationController;

  // SearchContainer height.
  late Animation _containerHeight;

  // Place options opacity.
  late Animation _listOpacity;

  List<dynamic>? _placePredictions = [];
  bool _isEditing = false;
  Geocoding? geocode;

  String _tempInput = "";
  String _currentInput = "";

  final FocusNode _fn = FocusNode();

  CrossFadeState? _crossFadeState;

  @override
  void initState() {

    geocode = Geocoding(apiKey: widget.apiKey, language: widget.language);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: 55, end: 364).animate(
      CurvedAnimation(
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );

    _textEditingController.addListener(_autocompletePlace);
    customListener();

    if (widget.hasClearButton) {
      _fn.addListener(() async {
        if (_fn.hasFocus) {
          setState(() => _crossFadeState = CrossFadeState.showSecond);
        } else {
          setState(() => _crossFadeState = CrossFadeState.showFirst);
        }
      });
      _crossFadeState = CrossFadeState.showFirst;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
    child: _searchContainer(
      child: _searchInput(context),
    ),
  );

  /*
  WIDGETS
  */
  Widget _searchContainer({Widget? child}) {

    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            height: _containerHeight.value,
            decoration: _containerDecoration(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: child,
                ),
                if (_placePredictions!.isNotEmpty)
                  Opacity(
                    opacity: _listOpacity.value,
                    child: Column(
                      children: <Widget>[
                        for (var prediction in _placePredictions!)
                          _placeOption(Place.fromJSON(prediction, geocode)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
    );
  }

  Widget _searchInput(BuildContext context) {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: _inputStyle(),
              controller: _textEditingController,
              onSubmitted: (_) => _selectPlace(),
              onEditingComplete: _selectPlace,
              enabled: widget.isEnabled,
              autofocus: false,
              focusNode: _fn,
              style: TextStyle(
                //fontSize: MediaQuery.of(context).size.width * 0.06,
                fontSize: 16,
                color: widget.isEnabled == false ? Colors.black38 : widget.darkMode ? Colors.grey[100] : Colors.grey[850],
              ),
            ),
          ),
          Container(width: 15),
          if (widget.hasClearButton)
            GestureDetector(

              onTap: () {
                if (_crossFadeState == CrossFadeState.showSecond) _textEditingController.clear();
              },

              child: AnimatedCrossFade(
                crossFadeState: _crossFadeState!,
                duration: const Duration(milliseconds: 300),
                firstChild: Icon(widget.icon, color: widget.iconColor),
                secondChild: Icon(Icons.clear, color: widget.iconColor),
              ),
            ),
          if (!widget.hasClearButton) Icon(widget.icon, color: widget.iconColor)
        ],
      ),
    );
  }

  Widget _placeOption(Place prediction) {
    String place = prediction.description!;

    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      onPressed: () => _selectPlace(prediction: prediction),
      child: ListTile(
        title: Text(
          place.length < 45 ? place : "${place.replaceRange(45, place.length, "")} ...",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
          ),
          maxLines: 1,
        ),
        trailing: SizedBox(
            height: SizeConfig().sh(14) as double?,
            width: SizeConfig().sw(14) as double?,
            child: const Icon(Icons.star_border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
      ),
    );
  }

  /*
  STYLING
  */
  InputDecoration _inputStyle() {
    return InputDecoration(
      hintText: "Enter destination or any address",
      border: InputBorder.none,
      hintStyle: TextStyle(
        color: widget.isEnabled == false ? Colors.black38 : widget.darkMode ? Colors.grey[100] : Colors.grey[850], fontWeight: FontWeight.w400
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: widget.darkMode ? Colors.grey[800] : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(9.0)),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 6)],
    );
  }

  /*
  METHODS
  */
  void _autocompletePlace() async {
    if (_fn.hasFocus) {
      setState(() {
        _currentInput = _textEditingController.text;
        _isEditing = true;
      });

      _textEditingController.removeListener(_autocompletePlace);

      if (_currentInput.isEmpty) {
        if (!_containerHeight.isDismissed) _closeSearch();
        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      if (_currentInput == _tempInput) {
        final predictions = await makeRequest(_currentInput);
        await _animationController.animateTo(0.5);
        setState(() => _placePredictions = predictions);
        await _animationController.forward();

        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _textEditingController.addListener(_autocompletePlace);
        if (_isEditing == true) _autocompletePlace();
      });
    }
  }

  /// API request function. Returns the Predictions
  Future<dynamic> makeRequest(input) async {
    String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}&language=${widget.language}";
    if (widget.location != null && widget.radius != null) {
      url += "&location=${widget.location!.latitude},${widget.location!.longitude}&country=NG&radius=${widget.radius}";
      if (widget.strictBounds) {
        url += "&strictbounds";
      }
      if (widget.placeType != null) {
        url += "&types=${widget.placeType!.apiString}";
      }
    }

    final response = await http.get(Uri.parse(url));
    final json = JSON.jsonDecode(response.body);

    if (json['error_message'] != null) {
      var error = json['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error += ' Make sure the Places API is activated on your Google Cloud Platform';
      }
      throw Exception(error);
    } else {
      final predictions = json['predictions'];
      return predictions;
    }
  }

  /// Will be called when a user selects one of the Place options
  void _selectPlace({Place? prediction}) async {
    if (prediction != null) {
      _textEditingController.value = TextEditingValue(
        text: prediction.description!,
        selection: TextSelection.collapsed(
          offset: prediction.description!.length,
        ),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Makes animation
    _closeSearch();

    // Calls the `onSelected` callback
    if (prediction is Place) widget.onSelected!(prediction);
  }

  /// Closes the expanded search box with predictions
  void _closeSearch() async {
    if (!_animationController.isDismissed) await _animationController.animateTo(0.5);
    _fn.unfocus();
    setState(() {
      _placePredictions = [];
      _isEditing = false;
    });
    _animationController.reverse();
    _textEditingController.addListener(_autocompletePlace);
  }

  /// Will listen for input changes every 0.5 seconds, allowing us to make API requests only when the user stops typing.
  void customListener() {
    Future.delayed(const Duration(milliseconds: 500), () {

      if(mounted) {
        setState(() => _tempInput = _textEditingController.text);
      }
      customListener();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    _fn.dispose();
    super.dispose();
  }
}
