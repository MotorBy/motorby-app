import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/services/reminder_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/reminder/reminder_details_viewmodel.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/utils/reminder_schedule.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/floating_snack_bar.dart';
import 'package:mobile_auto_drive/widgets/inputfield.dart';
import 'package:mobile_auto_drive/widgets/list_selector.dart';
import 'package:mobile_auto_drive/widgets/loader.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

/// Everything about one reminder, including the car it belongs to, with an
/// inline edit mode.
///
/// Opened from the reminder list with the reminder in hand, or from a
/// notification tap with just its id.
class ReminderDetailsScreen extends StatefulWidget {
  const ReminderDetailsScreen({super.key, this.reminder, this.reminderId})
      : assert(reminder != null || reminderId != null);

  final ReminderPayload? reminder;
  final String? reminderId;

  @override
  State<ReminderDetailsScreen> createState() => _ReminderDetailsScreenState();
}

class _ReminderDetailsScreenState extends State<ReminderDetailsScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _startEditing(ReminderDetailsViewModel model) {
    model.startEditing();
    _titleController.text = model.draft!.title;
    _descriptionController.text = model.draft!.description;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReminderDetailsViewModel>.reactive(
      viewModelBuilder: () => ReminderDetailsViewModel(),
      onViewModelReady: (model) => model.init(
        initial: widget.reminder,
        reminderId: widget.reminderId ?? widget.reminder?.id,
      ),
      builder: (context, model, child) {
        final reminder = model.reminder;

        return PopScope(
          // Leaving with unsaved edits drops them back to the details view
          // first instead of losing them on a stray back tap.
          canPop: !model.isEditing,
          onPopInvoked: (didPop) {
            if (!didPop && model.isEditing) model.cancelEditing();
          },
          child: Scaffold(
            backgroundColor: XColors.background(),
            appBar: appBarHeader(
              hasOnBack: true,
              context: context,
              appBarTitle: model.isEditing ? 'Edit reminder' : 'Reminder',
              centerTitle: false,
              onCloseAction: () {
                if (model.isEditing) {
                  model.cancelEditing();
                } else {
                  popView(context);
                }
              },
              actions: [
                if (reminder != null && !model.isEditing)
                  TextButton.icon(
                    onPressed: () => _startEditing(model),
                    icon: Icon(Icons.edit_outlined, size: 18, color: XColors.primaryColor()),
                    label: NormalText(
                      text: 'Edit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: XColors.primaryColor(),
                    ),
                  ),
                const XMargin(8),
              ],
            ),
            body: model.isBusy
                ? const Center(child: Loader())
                : reminder == null
                    ? _buildMissing(model)
                    : model.isEditing
                        ? _ReminderEditForm(
                            model: model,
                            titleController: _titleController,
                            descriptionController: _descriptionController,
                          )
                        : _ReminderDetailsView(model: model),
          ),
        );
      },
    );
  }

  Widget _buildMissing(ReminderDetailsViewModel model) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey[400]),
            const YMargin(12),
            NormalText(
              text: model.loadError ?? 'This reminder could not be found',
              fontSize: 14,
              textAlign: TextAlign.center,
              textColor: Colors.grey[700]!,
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Read-only view
// -----------------------------------------------------------------------------

class _ReminderDetailsView extends StatelessWidget {
  const _ReminderDetailsView({required this.model});

  final ReminderDetailsViewModel model;

  static final _dateFormat = DateFormat('EEE, d MMM yyyy');
  static final _stampFormat = DateFormat('d MMM yyyy, h:mm a');

  @override
  Widget build(BuildContext context) {
    final reminder = model.reminder!;
    final due = model.dueAt;
    final nextAlert = model.nextAlert();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(reminder),
          const YMargin(16),
          _Section(
            title: 'When',
            children: [
              _InfoRow(
                icon: Icons.event_outlined,
                label: 'Due date',
                value: due == null ? 'Not set' : _dateFormat.format(due),
              ),
              _InfoRow(
                icon: Icons.schedule_outlined,
                label: 'Time',
                value: due == null ? 'Not set' : formatDueTime(due.hour, due.minute),
              ),
              _InfoRow(
                icon: Icons.repeat,
                label: 'Repeats',
                value: frequencyLabel(reminder.frequency),
              ),
            ],
          ),
          const YMargin(16),
          _Section(
            title: 'Alerts',
            children: [
              _InfoRow(
                icon: Icons.notifications_active_outlined,
                label: 'Alert me',
                value: describeLead(reminder.remindBeforeMinutes),
              ),
              _InfoRow(
                icon: Icons.phone_iphone,
                label: 'Push notifications',
                value: reminder.pushEnabled ? 'On' : 'Off',
              ),
              _InfoRow(
                icon: Icons.alarm,
                label: 'Next alert',
                value: !reminder.pushEnabled
                    ? 'Turned off'
                    : nextAlert == null
                        ? 'None - this reminder has passed'
                        : _stampFormat.format(nextAlert),
              ),
            ],
          ),
          const YMargin(16),
          _Section(
            title: 'Car',
            children: [_carCard(context)],
          ),
          if ((reminder.description ?? '').isNotEmpty) ...[
            const YMargin(16),
            _Section(
              title: 'Notes',
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: NormalText(
                    text: reminder.description!,
                    fontSize: 14,
                    textColor: XColors.textColor(),
                    maxLines: 20,
                  ),
                ),
              ],
            ),
          ],
          const YMargin(20),
          if (reminder.createdAt != null)
            NormalText(
              text: 'Created ${_stampFormat.format(reminder.createdAt!.toLocal())}',
              fontSize: 12,
              textColor: Colors.grey[600]!,
            ),
          if (reminder.updatedAt != null && reminder.updatedAt != reminder.createdAt) ...[
            const YMargin(4),
            NormalText(
              text: 'Last updated ${_stampFormat.format(reminder.updatedAt!.toLocal())}',
              fontSize: 12,
              textColor: Colors.grey[600]!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _header(ReminderPayload reminder) {
    final status = _status();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: XColors.primaryColor().withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              getReminderCategoryIcon(reminder.effectiveCategory),
              color: XColors.primaryColor(),
              size: 26,
            ),
          ),
          const XMargin(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalText(
                  text: reminder.title?.isNotEmpty == true ? reminder.title! : 'Untitled reminder',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: XColors.black(),
                  maxLines: 2,
                ),
                const YMargin(6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Chip(text: reminder.effectiveCategory, color: XColors.primaryColor()),
                    _Chip(text: status.$1, color: status.$2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A short status and the colour to show it in.
  (String, Color) _status() {
    final now = DateTime.now();
    final next = model.nextOccurrence(now: now);
    if (next == null) {
      return model.dueAt == null ? ('No date', Colors.grey) : ('Passed', Colors.grey);
    }
    final days = DateTime(next.year, next.month, next.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (days == 0) return ('Due today', Colors.orange);
    if (days == 1) return ('Due tomorrow', Colors.orange);
    return ('Due in $days days', Colors.green);
  }

  Widget _carCard(BuildContext context) {
    final car = model.linkedCar;
    final budget = model.linkedBudget;

    if (car == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.directions_car_outlined, color: Colors.grey[500]),
            const XMargin(12),
            Expanded(
              child: NormalText(
                text: model.linkedCarMissing
                    ? 'The car this was set for is no longer in your garage'
                    : 'Not linked to a car. Tap Edit to choose one.',
                fontSize: 13,
                textColor: Colors.grey[700]!,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    final name = [car.carMake, car.carModel, car.carYear]
        .where((p) => p != null && p.isNotEmpty)
        .join(' ');
    final image = (car.images?.isNotEmpty ?? false) ? car.images!.first : null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => navigate(
        context,
        CarDetailsScreen(
          carData: car,
          budget: budget,
          currentBudgetIndex: model.budgetIndexFor(budget?.sId),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 52,
                width: 72,
                color: XColors.primaryColor().withOpacity(0.08),
                child: image == null
                    ? Icon(Icons.directions_car, color: XColors.primaryColor())
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.directions_car, color: XColors.primaryColor()),
                      ),
              ),
            ),
            const XMargin(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalText(
                    text: name.isEmpty ? 'Your car' : name,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    textColor: XColors.black(),
                  ),
                  if ((car.registrationNumber ?? '').isNotEmpty) ...[
                    const YMargin(2),
                    NormalText(
                      text: car.registrationNumber!,
                      fontSize: 12,
                      textColor: Colors.grey[600]!,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Edit form
// -----------------------------------------------------------------------------

class _ReminderEditForm extends StatelessWidget {
  const _ReminderEditForm({
    required this.model,
    required this.titleController,
    required this.descriptionController,
  });

  final ReminderDetailsViewModel model;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  static final _dateFormat = DateFormat('EEE, d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final draft = model.draft!;
    final errors = model.draftErrors;
    final saving = model.busy('save');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainInputField(
            label: 'Title',
            controller: titleController,
            isEnabled: true,
            textInputAction: TextInputAction.next,
            onChanged: (v) => model.updateDraft((d) => d.title = v),
          ),
          if (errors['title'] != null) _errorText(errors['title']!),
          const YMargin(14),
          MainInputField(
            label: 'Notes',
            controller: descriptionController,
            isEnabled: true,
            maxLines: 3,
            onChanged: (v) => model.updateDraft((d) => d.description = v),
          ),
          const YMargin(18),
          _Section(
            title: 'When',
            children: [
              _PickerRow(
                icon: Icons.event_outlined,
                label: 'Date',
                value: draft.date == null ? 'Pick a date' : _dateFormat.format(draft.date!),
                onTap: () async {
                  final now = DateTime.now();
                  final initial = draft.date ?? now;
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initial,
                    // Allow keeping a past date on a repeating reminder.
                    firstDate: initial.isBefore(now) ? initial : now,
                    lastDate: DateTime(now.year + 10),
                  );
                  if (picked != null) model.updateDraft((d) => d.date = picked);
                },
              ),
              if (errors['date'] != null) _errorText(errors['date']!),
              _PickerRow(
                icon: Icons.schedule_outlined,
                label: 'Time',
                value: draft.dueTimeText,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: draft.hour, minute: draft.minute),
                  );
                  if (picked != null) {
                    model.updateDraft((d) {
                      d.hour = picked.hour;
                      d.minute = picked.minute;
                    });
                  }
                },
              ),
              _PickerRow(
                icon: Icons.repeat,
                label: 'Repeats',
                value: frequencyLabel(draft.frequency),
                onTap: () => listHelperPicker(
                  context: context,
                  title: 'Repeats',
                  listString: kReminderFrequencies.map(frequencyLabel).toList(),
                  selected: (v) => model.updateDraft(
                      (d) => d.frequency = (v ?? draft.frequency).toLowerCase()),
                ),
              ),
            ],
          ),
          const YMargin(16),
          _Section(
            title: 'Details',
            children: [
              _PickerRow(
                icon: getReminderCategoryIcon(draft.category),
                label: 'Category',
                value: draft.category,
                onTap: () => listHelperPicker(
                  context: context,
                  title: 'Category',
                  listString: kReminderCategories,
                  selected: (v) => model.updateDraft((d) => d.category = v ?? d.category),
                ),
              ),
              _PickerRow(
                icon: Icons.directions_car_outlined,
                label: 'Car',
                value: _carLabel(model.budgetFor(draft.budgetId)),
                onTap: () => _pickCar(context),
              ),
            ],
          ),
          const YMargin(16),
          _Section(
            title: 'Alerts',
            children: [
              _PickerRow(
                icon: Icons.notifications_active_outlined,
                label: 'Alert me',
                value: describeLead(draft.remindBefore),
                onTap: () {
                  final labels = kLeadTimeOptions.map(describeLead).toList();
                  listHelperPicker(
                    context: context,
                    title: 'Alert me',
                    listString: labels,
                    selected: (v) {
                      final index = labels.indexOf(v ?? '');
                      if (index >= 0) {
                        model.updateDraft((d) => d.remindBefore = kLeadTimeOptions[index]);
                      }
                    },
                  );
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: draft.push,
                activeColor: XColors.primaryColor(),
                onChanged: (v) => model.updateDraft((d) => d.push = v),
                title: const NormalText(text: 'Push notifications', fontSize: 14),
                subtitle: NormalText(
                  text: draft.push
                      ? 'You will be alerted on this phone'
                      : 'No alert will be shown for this reminder',
                  fontSize: 12,
                  textColor: Colors.grey[600]!,
                ),
              ),
            ],
          ),
          const YMargin(24),
          XButton(
            onPressed: model.hasDraftChanges && !saving
                ? () => model.save(
                      onCallBack: () => FloatingSnackBar.show(
                        context,
                        'Reminder updated',
                        isError: false,
                      ),
                      onErrorBack: (e) => FloatingSnackBar.show(
                        context,
                        e ?? 'Could not save this reminder',
                        isError: true,
                      ),
                    )
                : null,
            text: 'Save changes',
            isLoading: saving,
            height: 52,
            textColor: Colors.white,
            buttonColor: model.hasDraftChanges ? XColors.primaryColor() : Colors.grey,
          ),
          const YMargin(8),
          TextButton(
            onPressed: saving ? null : model.cancelEditing,
            child: NormalText(
              text: 'Cancel',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              textColor: Colors.grey[700]!,
            ),
          ),
        ],
      ),
    );
  }

  String _carLabel(Budget? budget) {
    final car = budget?.carId;
    if (car == null) return 'No car';
    final name = [car.carMake, car.carModel, car.carYear]
        .where((p) => p != null && p.isNotEmpty)
        .join(' ');
    return name.isEmpty ? 'Your car' : name;
  }

  void _pickCar(BuildContext context) {
    final budgets = model.linkableBudgets;
    final labels = ['No car', ...budgets.map(_carLabel)];

    listHelperPicker(
      context: context,
      title: 'Which car is this for?',
      listString: labels,
      selected: (v) {
        final index = labels.indexOf(v ?? '');
        if (index < 0) return;
        model.updateDraft((d) => d.budgetId = index == 0 ? null : budgets[index - 1].sId);
      },
    );
  }

  Widget _errorText(String message) => Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: NormalText(text: message, fontSize: 12, textColor: Colors.red),
      );
}

// -----------------------------------------------------------------------------
// Pieces
// -----------------------------------------------------------------------------

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            text: title,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            textColor: Colors.grey[600]!,
          ),
          const YMargin(4),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: XColors.primaryColor()),
          const XMargin(12),
          NormalText(text: label, fontSize: 14, textColor: XColors.textColor()),
          const XMargin(12),
          Expanded(
            child: NormalText(
              text: value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: XColors.black(),
              textAlign: TextAlign.end,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 20, color: XColors.primaryColor()),
            const XMargin(12),
            NormalText(text: label, fontSize: 14, textColor: XColors.textColor()),
            const XMargin(12),
            Expanded(
              child: NormalText(
                text: value,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: XColors.black(),
                textAlign: TextAlign.end,
                maxLines: 1,
              ),
            ),
            const XMargin(4),
            const Icon(Icons.chevron_right, size: 20, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: NormalText(
        text: text,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        textColor: color,
      ),
    );
  }
}
