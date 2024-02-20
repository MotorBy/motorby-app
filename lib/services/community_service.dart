import 'package:http/http.dart' as http;
import 'package:mobile_auto_drive/models/community_model.dart';
import 'package:mobile_auto_drive/models/discussion_model.dart';
import 'dart:convert' as JSON;
import 'package:mobile_auto_drive/services/api_helper.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class CommunityService {
  final persistService = serviceLocator<PersistenceService>();

  List<Community>? communities = [];
  List<Discussion> discussions = [];

  String? communityId;
  Community? selectedCommunity;

  Future getCommunities() async {

    var response = await http.get(Uri.parse(APIService.getCommunities),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    if(response.statusCode == 200 || response.statusCode == 201) {
      CommunityModel res = CommunityModel.fromJson(json);
      communities = res.communities;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future getDiscussions() async {

    var url = '';

    if(communityId == null) {
      url = APIService.getDiscussions;
    } else {
      url = '${APIService.getDiscussions}/?community_id=$communityId';
    }

    var response = await http.get(Uri.parse(url),
        headers: APIHelper().requestHeadersWithToken());

    final json = JSON.jsonDecode(response.body);

    print(url);
    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {
      DiscussionModel res = DiscussionModel.fromJson(json);
      discussions = res.discussions!;
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future addDiscussions({String? content}) async {

    var discussData = {
      "content" : content,
      "community_id" : communityId,
      "user_id": persistService.getUserID
    };

    final jsonData = JSON.json.encode(formatObject(discussData));

    var response = await http.post(Uri.parse(
        APIService.addDiscussions),
        headers: APIHelper().requestHeadersWithToken(),
      body: jsonData
    );

    final json = JSON.jsonDecode(response.body);

    print(json.toString());

    if(response.statusCode == 200 || response.statusCode == 201) {
      await getDiscussions();
    } else {
      var error = json["message"];
      throw Exception(error);
    }

  }

  Future addComments() async {

  }

  Future joinCommunity() async {

  }

}