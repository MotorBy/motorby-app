import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

class ReminderViewModel extends BaseViewModel {
  final _reminderService = serviceLocator<ReminderService>();

  List<ReminderPayload> _reminders = [];
  List<ReminderPayload> get reminders => _reminders;

  Future<void> initialize({bool? reload = false}) async {
    setBusy(true);
    try {

      if(reload == true) {

        await getReminderList();

      } else {

        if(_reminderService.reminderListModel != null) {

          _reminders = _reminderService.reminderListModel!.data;
          notifyListeners();
          return;

        } else {
          await getReminderList();
        }

      }

    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }


  Future getReminderList() async {

    await _reminderService.getReminders().then((value) {
      _reminders = value;
    }).onError((error, stackTrace) {
      print(stackTrace);
    });

  }

}