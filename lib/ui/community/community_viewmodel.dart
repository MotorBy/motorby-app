import 'package:mobile_auto_drive/models/community_model.dart';
import 'package:mobile_auto_drive/models/discussion_model.dart';
import 'package:mobile_auto_drive/services/community_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:stacked/stacked.dart';

class CommunityViewModel extends BaseViewModel {
  final userService = serviceLocator<UserService>();
  final persistentService = serviceLocator<PersistenceService>();
  final communityService = serviceLocator<CommunityService>();

  List<Community>? communities = [];
  Community? selectedCommunity;
  int? currentIndex = 0;

  List<Discussion> discussions = [];

  Discussion? currentDiscussion;
  int? currentDiscussionIndex = 0;

  String? contentText = '';
  String? commentText = '';

  String? userId = '';

  String? communityId;

  Future initialise() async {
    await getCommunities();
  }

  Future getCommunities() async {
    setBusy(true);

    userId = persistentService.getUserID;

    await communityService.getCommunities().then((value) {
      communities = communityService.communities;
      setBusy(false);
    }).onError((error, stackTrace) {
      print(stackTrace.toString());
      setBusy(false);
    });

  }

  Future getDiscussions() async {

    setBusy(true);

    await communityService.getDiscussions().then((value) {
      discussions = communityService.discussions.reversed.toList();
      setBusy(false);
    }).onError((error, stackTrace) {
      print(stackTrace);
      setBusy(false);
    });

  }

  void onSelectCommunity({Community? community}) {
    selectedCommunity = community;

    if(community != null) {
      communityService.selectedCommunity = selectedCommunity;
      communityService.communityId = selectedCommunity!.id;
    } else {
      communityService.communityId = null;
    }

    notifyListeners();
  }

  void onContentUpdate({String? s, bool? isComment = false}) {
    if(isComment!) {
      commentText = s;
    } else {
      contentText = s;
    }
    notifyListeners();
  }

  Future addDiscussions({Function? onCallBack,}) async {
    setBusyForObject('discussion', true,);

    await communityService.addDiscussions(content: contentText).then((value) {
      discussions = communityService.discussions.reversed.toList();
      setBusyForObject('discussion', false,);

      if(onCallBack != null) {
        onCallBack();
      }

    }).onError((error, stackTrace) {
      print(stackTrace);
      setBusyForObject('discussion', false,);
    });

  }

  Future addComments({String? discussionId, Function? onCallBack, Function(String? e)? onErrorCallBack,}) async {
    setBusyForObject('comment', true,);

    await communityService.addComments(
        comment: commentText,
        discussionId: discussionId
    ).then((value) async {

      await getDiscussions();

      discussions = communityService.discussions.reversed.toList();
      currentDiscussion = discussions[currentDiscussionIndex!];

      setBusyForObject('comment', false,);

      if(onCallBack != null) {
        onCallBack();
      }

    }).onError((error, stackTrace) {
      print(stackTrace);
      onErrorCallBack!(error.toString());
      setBusyForObject('discussion', false,);
    });

  }

  void setCurrentDiscussion({int? currentIndex}){

    currentDiscussionIndex = currentIndex;
    currentDiscussion = discussions[currentDiscussionIndex!];

    notifyListeners();
  }

  Future joinCommunity({Community? community, int? index}) async {
    selectedCommunity = community;
    currentIndex = index;

    communityService.selectedCommunity = selectedCommunity;

    setBusyForObject('join', true);
    await communityService.joinCommunity().then((value) {
      initialise();
      notifyListeners();
      setBusyForObject('join', false);
    }).onError((error, stackTrace) {
      setBusyForObject('join', false);
    });
  }

  Future makeComments() async {

  }



}