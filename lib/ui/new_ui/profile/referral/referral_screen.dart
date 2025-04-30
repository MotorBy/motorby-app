import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/referral/referral_viewmodel.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:mobile_auto_drive/utils/data_handling.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'dart:ui';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReferralViewModel>.reactive(
      viewModelBuilder: () => ReferralViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: XColors.background(),
          appBar: appBarHeader(
            hasOnBack: true,
            context: context,
            appBarTitle: 'Referrals & Earnings',
          ),
          body: model.isBusy
              ? Center(child: CircularProgressIndicator(color: XColors.primaryColor2()))
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        XColors.highlightColor().withOpacity(0.1),
                        XColors.white(),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReferralCodeCard(context, model),
                        const SizedBox(height: 35),
                        _buildEarningsCard(model),
                        const SizedBox(height: 35),
                        _buildReferralHistorySection(model),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildReferralCodeCard(BuildContext context, ReferralViewModel model) {
    return Card(
      elevation: 0,
      shadowColor: XColors.primaryColor().withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              XColors.white(),
              XColors.secondaryColor().withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    color: XColors.primaryColor2(),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Referral Code',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      XColors.primaryColor2().withOpacity(0.8),
                      XColors.primaryColor().withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: XColors.primaryColor().withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.referralCode,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: XColors.white(),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: model.referralCode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                                  SizedBox(width: 8),
                                  Text('Code copied to clipboard'),
                                ],
                              ),
                              backgroundColor: XColors.primaryColor2(),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.copy_rounded,
                            color: XColors.white(),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement share functionality
                },
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share with friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: XColors.white(),
                  foregroundColor: XColors.primaryColor2(),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: XColors.primaryColor2().withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsCard(ReferralViewModel model) {
    return Card(
      elevation: 0,
      shadowColor: XColors.primaryColor().withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: XColors.white(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: XColors.primaryColor2(),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your Earnings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEarningsStat(
                    'Total Earnings',
                    amtFormatter(model.totalEarnings.toInt()),
                    Icons.monetization_on_outlined,
                  ),
                  Container(height: 50, width: 1, color: Colors.grey.withOpacity(0.3)),
                  _buildEarningsStat(
                    'Total Referrals',
                    model.totalReferrals.toString(),
                    Icons.people_outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: XColors.primaryColor(), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold,
            color: XColors.primaryColor2(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildReferralHistorySection(ReferralViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              color: XColors.primaryColor2(),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Referral History',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (model.referralHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No referrals yet',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )

        else
          ...model.referralHistory.map((history) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shadowColor: Colors.grey.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: XColors.secondaryColor().withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            history.userName.substring(0, 1),
                            style: TextStyle(
                              color: XColors.primaryColor2(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              history.userName,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              history.date.toString().split(' ')[0],
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amtFormatter(history.earnings.toInt()),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: XColors.primaryColor2(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: history.status == 'Completed'
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              history.status,
                              style: TextStyle(
                                color: history.status == 'Completed'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }
}