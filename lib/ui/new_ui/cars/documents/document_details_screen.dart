import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/widgets/app_bar.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final CarDocument document;

  const DocumentDetailsScreen({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarHeader(
        hasOnBack: true,
        context: context,
        appBarTitle: document.documentName,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (document.documentPath != null) ... [
              if (document.documentPath!.toLowerCase().endsWith('.pdf'))
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
                  ),
                )
              else
                Container(
                  //height: 350,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      document.documentPath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],

            _buildInfoRow('Category', document.documentType!),
            const SizedBox(height: 16),
            _buildInfoRow('Document name', document.documentName!),
            if (document.documentExpiryDate != null) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                'Expiry Date', 
                '${document.documentExpiryDate}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NormalText(
          text: label,
          fontSize: 14,
          textColor: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        NormalText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}