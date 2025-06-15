import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_auto_drive/models/insurance_bought_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/insurance_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/new_claim_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/insurance/view_claim_details.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/button.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';
import 'package:stacked/stacked.dart';

class InsuranceHistoryScreen extends StatefulWidget {
  const InsuranceHistoryScreen({super.key, this.viewModel});

  final InsuranceViewModel? viewModel;

  @override
  State<InsuranceHistoryScreen> createState() => _InsuranceHistoryScreenState();
}

class _InsuranceHistoryScreenState extends State<InsuranceHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late InsuranceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _viewModel = widget.viewModel ?? InsuranceViewModel();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InsuranceViewModel>.reactive(
        viewModelBuilder: () => _viewModel,
        disposeViewModel: false,
        builder: (context, model, child) => Scaffold(
              appBar: appBarHeader(
                hasOnBack: true,
                context: context,
                appBarTitle: 'Insurance history',
              ),
              backgroundColor: XColors.background(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const YMargin(12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        // ContainerWidget(
                        //   padding: const EdgeInsets.all(16),
                        //   backgroundColor: XColors.primaryColor2().withOpacity(0.1),
                        //   borderRadius: BorderRadius.circular(12),
                        //   child: Row(
                        //     children: [
                        //       const GetSvgImage(image: 'assets/images/insurance-icon.svg'),
                        //       const XMargin(12),
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             NormalText(
                        //               text: 'Active Insurance',
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w600,
                        //               textColor: XColors.primaryColor2(),
                        //             ),
                        //             const YMargin(4),
                        //             const NormalText(
                        //               text: 'Comprehensive Coverage',
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w400,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       ContainerWidget(
                        //         onTap: () {
                        //           navigate(context, const NewClaimScreen());
                        //         },
                        //         backgroundColor: XColors.primaryColor2(),
                        //         borderRadius: BorderRadius.circular(8),
                        //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        //         child: const NormalText(
                        //           text: '+ New Claim',
                        //           fontSize: 14,
                        //           fontWeight: FontWeight.w600,
                        //           textColor: Colors.white,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //const YMargin(24),
                        TabBar(
                          controller: _tabController,
                          labelColor: XColors.primaryColor2(),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: XColors.primaryColor2(),
                          tabs: const [
                            Tab(text: 'Active'),
                            Tab(text: 'Pending'),
                            Tab(text: 'Claims'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const YMargin(16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildActivePoliciesList(viewModel: model),
                        buildPendingPoliciesList(viewModel: model),
                        buildClaimsHistoryList(viewModel: model),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

}

Widget buildActivePoliciesList({InsuranceViewModel? viewModel}) {
  final activeInsurances = viewModel?.insuranceBought?.payload
      ?.where((insurance) => insurance.active == true)
      .toList() ??
      [];

  if (viewModel!.isBusy) {
    return const Center(child: CircularProgressIndicator());
  }

  if (activeInsurances.isEmpty) {
    return const Center(
      child: NormalText(
        text: 'No active insurance policies found',
        fontSize: 16,
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    itemCount: activeInsurances.length,
    itemBuilder: (context, index) {
      final insurance = activeInsurances[index];
      return ContainerWidget(
        margin: const EdgeInsets.only(bottom: 16),
        backgroundColor: XColors.white(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: insurance.insuranceType?.type ?? 'Insurance Policy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: XColors.primaryColor2().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: NormalText(
                    text: insurance.insuranceStatus ?? 'Active',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: XColors.primaryColor2(),
                  ),
                ),
              ],
            ),
            const YMargin(12),
            Row(
              children: [
                _buildInfoItem(
                    'Start Date', _formatDate(insurance.createdAt)),
                const XMargin(24),
                _buildInfoItem('End Date',
                    _formatDate(insurance.insuranceData!.insuranceEndDate)),
              ],
            ),
            const YMargin(12),
            _buildInfoItem('Coverage Amount',
                insurance.insuranceType?.cost?.toString() ?? 'N/A'),
            const YMargin(6),
            Row(
              children: [
                Expanded(
                  child: ContainerWidget(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => buildInsuranceProductInfo(
                            insurance: insurance,
                            context: context
                        ),
                      );
                    },
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: NormalText(
                        text: 'View Details',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.primaryColor2(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (index != 2) ...[
              const YMargin(12),
              Divider(
                color: Colors.grey.withOpacity(0.3),
                thickness: 1,
              ),
            ]
          ],
        ),
      );
    },
  );
}

Widget buildPendingPoliciesList({InsuranceViewModel? viewModel}) {
  final pendingInsurances = viewModel?.insuranceBought?.payload
      ?.where((insurance) =>
  insurance.insuranceStatus == "PENDING" ||
      insurance.paymentStatus?.toLowerCase() == 'pending')
      .toList() ??
      [];

  if (viewModel!.isBusy) {
    return const Center(child: CircularProgressIndicator());
  }

  if (pendingInsurances.isEmpty) {
    return const Center(
      child: NormalText(
        text: 'No pending insurance policies',
        fontSize: 16,
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    itemCount: pendingInsurances.length,
    itemBuilder: (context, index) {
      final insurance = pendingInsurances[index];
      return ContainerWidget(
        margin: const EdgeInsets.only(bottom: 16),
        backgroundColor: XColors.white(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: insurance.insuranceType?.product ?? 'Insurance Policy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: NormalText(
                    text: insurance.insuranceStatus ?? 'Pending',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: Colors.amber,
                  ),
                ),
              ],
            ),
            const YMargin(12),
            Row(
              children: [
                _buildInfoItem(
                    'Purchased Date',
                    _formatDate(insurance.createdAt)
                ),
                const XMargin(24),
                _buildInfoItem('End Date', "N/A"),
              ],
            ),
            const YMargin(12),
            _buildInfoItem('Coverage Amount', insurance.insuranceType?.cost != null ? "NGN${amtFormatter(int.parse(insurance.insuranceType?.cost))}" ?? 'N/A' : "N/A"),
            const YMargin(6),
            Row(
              children: [
                Expanded(
                  child: ContainerWidget(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => Container(
                          decoration: BoxDecoration(
                            color: XColors.white(),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const NormalText(
                                    text: 'Insurance Details',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              const YMargin(24),
                              _buildInfoItem(
                                  'Insurance Type',
                                  insurance.insuranceType?.type
                                      ?.replaceAll('buy-', '')
                                      .replaceAll('-', ' ') ??
                                      'N/A'),
                              const YMargin(16),
                              _buildInfoItem(
                                  'Insurance id', insurance.id ?? 'N/A'),
                              const YMargin(16),
                              _buildInfoItem('Coverage Amount',
                                  '${insurance.insuranceType?.cost?.toString() ?? 'N/A'} NGN'),
                              const YMargin(16),
                              _buildInfoItem('Date initiated',
                                  _formatDate(insurance.createdAt)),
                              const YMargin(16),
                              _buildInfoItem('Status',
                                  insurance.insuranceStatus ?? 'Pending'),
                              const YMargin(16),
                              _buildInfoItem('Payment Status',
                                  insurance.paymentStatus ?? 'N/A'),

                            ],
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: NormalText(
                        text: 'View Details',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.primaryColor2(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (index != 2) ...[
              const YMargin(12),
              Divider(
                color: Colors.grey.withOpacity(0.3),
                thickness: 1,
              ),
            ]
          ],
        ),
      );
    },
  );
}

Widget buildClaimsHistoryList({InsuranceViewModel? viewModel}) {
  final claimedInsurances = viewModel?.insuranceBought?.payload
      ?.where((insurance) => insurance.claimed == true)
      .toList() ??
      [];

  if (viewModel!.isBusy) {
    return const Center(child: CircularProgressIndicator());
  }

  if (claimedInsurances.isEmpty) {
    return const Center(
      child: NormalText(
        text: 'No insurance claims found',
        fontSize: 16,
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    itemCount: claimedInsurances.length,
    itemBuilder: (context, index) {
      final insurance = claimedInsurances[index];
      return ContainerWidget(
        margin: const EdgeInsets.only(bottom: 16),
        backgroundColor: XColors.white(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: insurance.insuranceType?.type ?? 'Insurance Policy',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(insurance.claimStatus)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: NormalText(
                    text: insurance.claimStatus ?? 'Pending',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: _getStatusColor(insurance.claimStatus),
                  ),
                ),
              ],
            ),
            const YMargin(12),
            Row(
              children: [
                _buildInfoItem(
                    'Claim Date', _formatDate(insurance.createdAt)),
                const XMargin(24),
                _buildInfoItem(
                    'Last Updated', _formatDate(insurance.updatedAt)),
              ],
            ),
            const YMargin(12),
            _buildInfoItem('Coverage Amount',
                insurance.insuranceType?.cost?.toString() ?? 'N/A'),
            const YMargin(12),
            _buildInfoItem(
                'Insurance Status', insurance.insuranceStatus ?? 'N/A'),
            const YMargin(16),
            Row(
              children: [
                Expanded(
                  child: ContainerWidget(
                    onTap: () {
                      navigate(
                          context, const ViewClaimDetails(status: 'Settled'));
                    },
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: NormalText(
                        text: 'View Details',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.primaryColor2(),
                      ),
                    ),
                  ),
                ),
                const XMargin(12),
                Expanded(
                  child: ContainerWidget(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.white,
                    borderColor: XColors.primaryColor2(),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: NormalText(
                        text: 'Contact Support',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: XColors.black(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (index != 3) ...[
              const YMargin(12),
              Divider(
                color: Colors.grey.withOpacity(0.3),
                thickness: 1,
              ),
            ]
          ],
        ),
      );
    },
  );
}

Widget buildInsuranceProductInfo({Payload? insurance, BuildContext? context}) {
  return Container(
    decoration: BoxDecoration(
      color: XColors.white(),
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20)),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            const NormalText(
              text: 'Insurance Details',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            IconButton(
              onPressed: () => Navigator.pop(context!),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const YMargin(24),
        _buildInfoItem('Insurance Type',
            insurance!.insuranceType?.type ?? 'N/A'),
        const YMargin(16),
        _buildInfoItem(
            'Policy Number', insurance.id ?? 'N/A'),
        const YMargin(16),
        _buildInfoItem('Coverage Amount',
            '${insurance.insuranceType?.cost?.toString() ?? 'N/A'} NGN'),
        const YMargin(16),
        _buildInfoItem('Start Date',
            _formatDate(insurance.createdAt)),
        const YMargin(16),
        _buildInfoItem(
            'End Date',
            _formatDate(insurance
                .insuranceData?.insuranceEndDate)),
        const YMargin(16),
        _buildInfoItem('Status',
            insurance.insuranceStatus ?? 'N/A'),
        const YMargin(16),
        _buildInfoItem('Payment Status',
            insurance.paymentStatus ?? 'N/A'),
        const YMargin(24),
        XButton(
          onPressed: () {

            Navigator.pop(context);
            navigate(context, const NewClaimScreen());

          },
          text: 'Make Claim',
          isLoading: false,
          width: MediaQuery.of(context!).size.width,
          buttonColor: XColors.primaryColor(),
        ),

      ],
    ),
  );
}

String _formatDate(DateTime? date) {
  if (date == null) return 'N/A';
  return DateFormat('dd MMM yyyy').format(date);
}

Widget _buildInfoItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      NormalText(
        text: label,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        textColor: Colors.grey,
      ),
      const YMargin(4),
      NormalText(
        text: value,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ],
  );
}

Color _getStatusColor(String? status) {
  if (status == null) return Colors.grey;

  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'approved':
    case 'active':
      return Colors.green;
    case 'settled':
      return Colors.blue;
    case 'rejected':
    case 'failed':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
