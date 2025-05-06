import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/new_claim_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/insurance/view_claim_details.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';
import 'package:mobile_auto_drive/utils/margin.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/app_container_widget.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key});

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHeader(
        hasOnBack: true,
        context: context,
        appBarTitle: 'Insurance history',
      ),
      backgroundColor: XColors.background(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const YMargin(12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                ContainerWidget(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: XColors.primaryColor2().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      const GetSvgImage(image: 'assets/images/insurance-icon.svg'),
                      const XMargin(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NormalText(
                              text: 'Active Insurance',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textColor: XColors.primaryColor2(),
                            ),
                            const YMargin(4),
                            const NormalText(
                              text: 'Comprehensive Coverage',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      ContainerWidget(
                        onTap: () {
                          navigate(context, const NewClaimScreen());
                        },
                        backgroundColor: XColors.primaryColor2(),
                        borderRadius: BorderRadius.circular(8),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: const NormalText(
                          text: '+ New Claim',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(24),
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
                _buildActivePoliciesList(),
                _buildPendingPoliciesList(),
                _buildClaimsHistoryList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePoliciesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      itemCount: 2, // Replace with actual data length
      itemBuilder: (context, index) {
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
                  const NormalText(
                    text: 'Comprehensive Coverage',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: XColors.primaryColor2().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: NormalText(
                      text: 'Active',
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
                  _buildInfoItem('Start Date', '01 Jan 2024'),
                  const XMargin(24),
                  _buildInfoItem('End Date', '31 Dec 2024'),
                ],
              ),
              const YMargin(12),
              _buildInfoItem('Coverage Amount', '\$50,000'),
              const YMargin(6),
              Row(
                children: [
                  Expanded(
                    child: ContainerWidget(
                      onTap: () {
                        navigate(context, const ViewClaimDetails(status: 'Active'));
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
              if(index != 2) ... [
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

  Widget _buildPendingPoliciesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      itemCount: 2, // Replace with actual data length
      itemBuilder: (context, index) {
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
                  const NormalText(
                    text: 'Comprehensive Coverage',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const NormalText(
                      text: 'Pending',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              const YMargin(12),
              Row(
                children: [
                  _buildInfoItem('Purchase Date', '15 Jan 2024'),
                  const XMargin(24),
                  _buildInfoItem('Activation Date', '01 Feb 2024'),
                ],
              ),
              const YMargin(12),
              _buildInfoItem('Coverage Amount', '\$50,000'),
              const YMargin(6),
              Row(
                children: [
                  Expanded(
                    child: ContainerWidget(
                      onTap: () {
                        navigate(context, const ViewClaimDetails(status: 'Pending'));
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
              if(index != 2) ... [
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

  Widget _buildClaimsHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      itemCount: 3, // Replace with actual data length
      itemBuilder: (context, index) {
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
                  const NormalText(
                    text: 'Accident Damage',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  _buildStatusBadge('Settled'),
                ],
              ),
              const YMargin(12),
              const NormalText(
                text: 'Claim filed on 15 Dec 2023',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              const YMargin(16),
              Row(
                children: [
                  Expanded(
                    child: ContainerWidget(
                      onTap: () {
                        navigate(context, const ViewClaimDetails(status: 'Settled'));
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
              if(index != 3) ... [
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

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'processing':
        backgroundColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        break;
      case 'settled':
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        break;
      case 'cancelled':
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: NormalText(
        text: status,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        textColor: textColor,
      ),
    );
  }

}

