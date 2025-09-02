import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BankPaymentScreen extends StatefulWidget {
  const BankPaymentScreen({super.key});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen>
    with TickerProviderStateMixin {
  final TextEditingController _referenceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _referenceFocusNode = FocusNode();

  String? selectedPaymentType;
  File? receiptImage;
  bool isSubmitting = false;
  bool _showValidationErrors = false;

  String applicationId = "9XAFGKFKA0242";
  double paymentAmount = 3000;

  // Payment type options
  final List<Map<String, dynamic>> paymentTypes = [
    {
      'type': '30% Payment',
      'description': 'Pay 30% now, remaining later',
      'icon': Icons.payment_outlined,
    },
    {
      'type': 'Half Payment',
      'description': 'Pay 50% now, remaining later',
      'icon': Icons.payment_outlined,
    },
    {
      'type': 'Full Payment',
      'description': 'Pay complete amount',
      'icon': Icons.account_balance_wallet_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _referenceController.addListener(_onReferenceChanged);
    _referenceFocusNode.addListener(_onReferenceFocusChanged);
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _referenceFocusNode.dispose();
    super.dispose();
  }

  void _onReferenceChanged() {
    if (_showValidationErrors) {
      setState(() {}); // Trigger rebuild for real-time validation
    }
  }

  void _onReferenceFocusChanged() {
    setState(() {}); // Update UI based on focus state
  }

  double get paymentAmountValue {
    if (selectedPaymentType == "30% Payment") {
      return paymentAmount * 0.3;
    }
    if (selectedPaymentType == "Half Payment") {
      return paymentAmount / 2;
    }
    return paymentAmount;
  }

  bool _canSubmitPayment() {
    return selectedPaymentType != null &&
        receiptImage != null &&
        _referenceController.text.trim().isNotEmpty;
  }

  String? _getReferenceValidationError() {
    if (!_showValidationErrors) return null;
    final text = _referenceController.text.trim();
    if (text.isEmpty) return 'Reference number is required';
    if (text.length < 6) return 'Reference number too short';
    return null;
  }

  Future<void> _pickReceiptImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          receiptImage = File(image.path);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Receipt uploaded successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _showValidationErrors = true;
    });

    if (!_canSubmitPayment()) {
      _showValidationFeedback();
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Navigate to receipt
        context.push(
          CustomerRoute.receipt.bankReceipt,
          extra: {
            'paymentType': selectedPaymentType,
            'referenceNumber': _referenceController.text.trim(),
            'receiptImage': receiptImage,
            'paymentAmount': paymentAmountValue,
            'applicationId': applicationId,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Error submitting payment: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _handleSubmit,
            ),
          ),
        );
      }
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showValidationFeedback() {
    List<String> errors = [];
    if (selectedPaymentType == null) errors.add('Payment type');
    if (receiptImage == null) errors.add('Receipt image');
    if (_referenceController.text.trim().isEmpty) {
      errors.add('Reference number');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Please complete the following:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            ...errors.map((error) => Text('• $error')),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _handleCancel() {
    if (selectedPaymentType != null ||
        receiptImage != null ||
        _referenceController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Cancel Payment'),
          content: Text(
            'Are you sure you want to cancel? All entered information will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Continue'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Yes, Cancel'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Bank Payment',
        titleTextStyle: TextStyle(
          fontSize: AppTextSize.md.size,
          fontWeight: AppFontWeight.black.value,
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(theme),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application Info Card with enhanced styling
                  _buildEnhancedSectionCard(
                    title: 'Application Details',
                    icon: Icons.info_outline,
                    theme: theme,
                    child: _buildApplicationDetails(colorScheme),
                  ),
                  const SizedBox(height: 16),

                  // Payment Type Selection with enhanced UI
                  _buildEnhancedSectionCard(
                    title: 'Select Payment Type',
                    icon: Icons.payment_outlined,
                    theme: theme,
                    child: _buildEnhancedPaymentTypeSelection(colorScheme),
                  ),
                  const SizedBox(height: 16),

                  // Animated additional fields
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: selectedPaymentType != null ? null : 0,
                    child: selectedPaymentType != null
                        ? _buildPaymentDetailsSection(theme, colorScheme)
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom action buttons
          if (selectedPaymentType != null)
            _buildFixedBottomActions(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    int currentStep = 1;
    if (selectedPaymentType != null) currentStep = 2;
    if (receiptImage != null && _referenceController.text.isNotEmpty) {
      currentStep = 3;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(64),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
        ),
      ),
      child: Row(
        children: [
          _buildStepIndicator(1, 'Payment Type', currentStep >= 1, theme),
          Expanded(child: _buildStepConnector(currentStep >= 2, theme)),
          _buildStepIndicator(2, 'Details', currentStep >= 2, theme),
          Expanded(child: _buildStepConnector(currentStep >= 3, theme)),
          _buildStepIndicator(3, 'Submit', currentStep >= 3, theme),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    int step,
    String label,
    bool isActive,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withAlpha(64),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withAlpha(128),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withAlpha(128),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive, ThemeData theme) {
    return Container(
      height: 2,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withAlpha(64),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildEnhancedSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required ThemeData theme,
    bool isHighlighted = false,
  }) {
    return Card(
      elevation: isHighlighted ? 4 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isHighlighted
            ? BorderSide(
                color: theme.colorScheme.primary.withAlpha(64),
                width: 1.5,
              )
            : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isHighlighted
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withAlpha(16),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomText.title(title, size: AppTextSize.md),
                ],
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationDetails(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withAlpha(64)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Application ID', applicationId, Icons.tag),
          Divider(height: 24, color: colorScheme.outline.withAlpha(64)),
          _buildInfoRow(
            'Total Amount',
            formatToPhpCurrency(paymentAmount),
            Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
        ),
        SizedBox(width: 8),
        Expanded(child: CustomText.body(label)),
        CustomText.body(value, fontWeight: AppFontWeight.bold.value),
      ],
    );
  }

  Widget _buildEnhancedPaymentTypeSelection(ColorScheme colorScheme) {
    return Column(
      children: paymentTypes.map((paymentOption) {
        final isSelected = selectedPaymentType == paymentOption['type'];

        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedPaymentType = paymentOption['type'];
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withAlpha(32)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withAlpha(64),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: paymentOption['type'],
                    groupValue: selectedPaymentType,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentType = value;
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  Icon(
                    paymentOption['icon'],
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withAlpha(128),
                    size: 24,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.body(
                          paymentOption['type'],
                          fontWeight: AppFontWeight.bold.value,
                          color: isSelected ? colorScheme.primary : null,
                        ),
                        SizedBox(height: 4),
                        CustomText.body(
                          paymentOption['description'],
                          size: AppTextSize.xs,
                          color: colorScheme.onSurface.withAlpha(160),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentDetailsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Payment Amount Display with enhanced styling
        _buildEnhancedSectionCard(
          title: 'Payment Amount',
          icon: Icons.account_balance_wallet_outlined,
          theme: theme,
          isHighlighted: true,
          child: _buildPaymentAmountDisplay(colorScheme),
        ),
        const SizedBox(height: 16),

        // Reference Number Field with validation
        _buildEnhancedSectionCard(
          title: 'Payment Reference',
          icon: Icons.numbers_outlined,
          theme: theme,
          child: _buildReferenceField(theme),
        ),
        const SizedBox(height: 16),

        // Receipt Upload Section with enhanced UI
        _buildEnhancedSectionCard(
          title: 'Upload Receipt',
          icon: Icons.receipt_long_outlined,
          theme: theme,
          child: _buildEnhancedReceiptUpload(theme),
        ),
        const SizedBox(height: 100), // Space for fixed bottom buttons
      ],
    );
  }

  Widget _buildPaymentAmountDisplay(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withAlpha(32),
            colorScheme.primaryContainer.withAlpha(16),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(64)),
      ),
      child: Column(
        children: [
          Icon(Icons.payments_rounded, color: colorScheme.primary, size: 32),
          SizedBox(height: 8),
          CustomText.body(
            'Amount to Pay',
            color: colorScheme.onSurface.withAlpha(160),
          ),
          const SizedBox(height: 8),
          CustomText.title(
            formatToPhpCurrency(paymentAmountValue),
            size: AppTextSize.lg,
            color: colorScheme.primary,
          ),
          if (selectedPaymentType == "30% Payment" ||
              selectedPaymentType == "Half Payment") ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(70),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withAlpha(64)),
              ),
              child: CustomText.body(
                'Remaining: ${formatToPhpCurrency(paymentAmount - paymentAmountValue)}',
                size: AppTextSize.xs,
                fontWeight: AppFontWeight.bold.value,
                color: Colors.orange.shade900,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReferenceField(ThemeData theme) {
    final hasError = _getReferenceValidationError() != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Enter the reference number from your bank transfer receipt',
          size: AppTextSize.sm,
          color: theme.colorScheme.onSurface.withAlpha(160),
        ),
        SizedBox(height: 12),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : _referenceFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withAlpha(64),
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: _referenceController,
            focusNode: _referenceFocusNode,
            decoration: InputDecoration(
              hintText: 'e.g., REF123456789',
              prefixIcon: Icon(
                Icons.numbers_outlined,
                color: hasError
                    ? theme.colorScheme.error
                    : _referenceFocusNode.hasFocus
                    ? theme.colorScheme.primary
                    : null,
              ),
              suffixIcon: _referenceController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _referenceController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              errorStyle: TextStyle(height: 0),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
          ),
        ),
        if (hasError) ...[
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: 4),
              CustomText.body(
                _getReferenceValidationError()!,
                size: AppTextSize.xs,
                color: theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEnhancedReceiptUpload(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Upload a clear photo of your bank transfer receipt',
          size: AppTextSize.sm,
          color: theme.colorScheme.onSurface.withAlpha(160),
        ),
        SizedBox(height: 12),

        if (receiptImage == null) ...[
          InkWell(
            onTap: _pickReceiptImage,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(128),
                  width: 2,
                  style: BorderStyle.values[1], // Dashed style simulation
                ),
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.primary.withAlpha(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(32),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomText.body(
                    'Tap to upload receipt',
                    fontWeight: AppFontWeight.bold.value,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(height: 4),
                  CustomText.body(
                    'JPG, PNG up to 5MB',
                    size: AppTextSize.xs,
                    color: theme.colorScheme.onSurface.withAlpha(128),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withAlpha(128), width: 2),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  child: Stack(
                    children: [
                      Image.file(
                        receiptImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(16),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomText.body(
                          'Receipt uploaded successfully',
                          color: Colors.green.shade700,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _pickReceiptImage,
                        icon: Icon(Icons.edit_outlined, size: 16),
                        label: Text('Change'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFixedBottomActions(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withAlpha(64)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: 'Submit Payment',
              onPressed: _canSubmitPayment() && !isSubmitting
                  ? _handleSubmit
                  : null,
              isLoading: isSubmitting,
              icon: Icons.send_outlined,
              isEnabled: _canSubmitPayment() && !isSubmitting,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Cancel',
              onPressed: !isSubmitting ? _handleCancel : null,
              icon: Icons.cancel_outlined,
              isEnabled: !isSubmitting,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
