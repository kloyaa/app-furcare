import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/payment.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/data/models/payment/payment_customer_details.dart';
import 'package:furcare_app/data/models/payment/payment_process_request.dart';
import 'package:furcare_app/data/models/payment/payment_request.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class PaymentOption {
  final String id;
  final String title;
  final PaymentType type;
  final double percentage;
  final String description;
  final IconData icon;

  const PaymentOption({
    required this.id,
    required this.title,
    required this.type,
    required this.percentage,
    required this.description,
    required this.icon,
  });
}

// Payment type options
final List<PaymentOption> paymentTypes = [
  PaymentOption(
    id: '50_payment',
    title: '50% Payment',
    type: PaymentType.partialPayment,
    percentage: 0.5,
    description: 'Pay 50% now, remaining later',
    icon: Icons.payment_outlined,
  ),
  PaymentOption(
    id: 'full_payment',
    title: 'Full Payment',
    type: PaymentType.fullPayment,
    percentage: 1.0,
    description: 'Pay the full amount now',
    icon: Icons.payment_outlined,
  ),
];

class GCashPaymentScreen extends StatefulWidget {
  const GCashPaymentScreen({super.key});

  @override
  State<GCashPaymentScreen> createState() => _GCashPaymentScreenState();
}

class _GCashPaymentScreenState extends State<GCashPaymentScreen>
    with TickerProviderStateMixin {
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final FocusNode _referenceFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  PaymentOption? selectedPayment;
  File? receiptImage;
  bool isSubmitting = false;
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    _referenceController.addListener(_onReferenceChanged);
    _phoneController.addListener(_onPhoneChanged);
    _referenceFocusNode.addListener(_onReferenceFocusChanged);
    _phoneFocusNode.addListener(_onPhoneFocusChanged);
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _phoneController.dispose();
    _referenceFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onReferenceChanged() {
    if (_showValidationErrors) {
      setState(() {}); // Trigger rebuild for real-time validation
    }
  }

  void _onPhoneChanged() {
    if (_showValidationErrors) {
      setState(() {}); // Trigger rebuild for real-time validation
    }
  }

  void _onReferenceFocusChanged() {
    setState(() {}); // Update UI based on focus state
  }

  void _onPhoneFocusChanged() {
    setState(() {}); // Update UI based on focus state
  }

  double get paymentAmountValue {
    PaymentSettingsProvider provider = context.read<PaymentSettingsProvider>();
    if (selectedPayment == null) {
      return provider.amount.toDouble();
    }
    return provider.amount * selectedPayment!.percentage;
  }

  bool _canSubmitPayment() {
    return selectedPayment != null &&
        receiptImage != null &&
        _referenceController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty;
  }

  String? _getPhoneValidationError() {
    if (!_showValidationErrors) return null;
    final text = _phoneController.text.trim();
    if (text.isEmpty) return 'Phone number is required';
    if (text.length < 11) return 'Invalid phone number format';
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
      final paymentSettingProvider = context.read<PaymentSettingsProvider>();
      final paymentProvider = context.read<PaymentProvider>();
      final clientProvider = context.read<ClientProvider>();

      paymentSettingProvider.setPaymentType(selectedPayment!.type);
      paymentSettingProvider.setReference(_referenceController.text.trim());
      paymentSettingProvider.setAccountNumber(_phoneController.text.trim());
      paymentSettingProvider.setAmountPaid(paymentAmountValue.toInt());

      if (receiptImage != null) {
        paymentSettingProvider.setReceipt(receiptImage!);
      }

      await paymentProvider.uploadPaymentReceipts(
        application: paymentSettingProvider.application,
        applicationModel: paymentSettingProvider.applicationType.value,
        media: [receiptImage!],
      );

      final paymentRequest = PaymentRequest(
        application: paymentSettingProvider.application,
        applicationModel: paymentSettingProvider.applicationType,
        amount: paymentSettingProvider.amountPaid.toDouble(),
        paymentMethod: paymentSettingProvider.paymentMethod,
        paymentType: paymentSettingProvider.paymentType,
        accountNumber: _phoneController.text.trim(),
      );

      await paymentProvider.createPayment(paymentRequest);

      if (paymentProvider.paymentResponse != null) {
        final payment = paymentProvider.paymentResponse;
        final paymentMethod = payment!.data.paymentMethod.toUpperCase();
        final paymentId = paymentSettingProvider.applicationId;

        await paymentProvider.processPayment(
          payment.data.id,
          PaymentProcessRequest(
            gatewayData: GatewayData(
              merchant: "Furcare GCash Gateway",
              reference: "$paymentMethod$paymentId",
              customerDetails: PaymentCustomerDetails(
                address: clientProvider.client.address,
                fullName: clientProvider.client.fullName,
              ),
            ),
          ),
        );
      }

      if (mounted) {
        // Navigate to receipt
        context.push(
          CustomerRoute.receipt.ewalletGcashReceipt,
          extra: {
            'phoneNumber': _phoneController.text.trim(),
            'receiptImage': receiptImage,
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
    if (selectedPayment == null) errors.add('Payment type');
    if (receiptImage == null) errors.add('Receipt image');
    if (_referenceController.text.trim().isEmpty) {
      errors.add('Reference number');
    }
    if (_phoneController.text.trim().isEmpty) {
      errors.add('Phone number');
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
    if (selectedPayment != null ||
        receiptImage != null ||
        _referenceController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty) {
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
      appBar: CustomListAppBar(title: 'GCash Payment'),
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
                  // GCash Provider Info
                  _buildGCashProviderCard(theme),
                  const SizedBox(height: 16),

                  // Application Info Card
                  _buildEnhancedSectionCard(
                    title: 'Application Details',
                    icon: Icons.info_outline,
                    theme: theme,
                    child: _buildApplicationDetails(colorScheme),
                  ),
                  const SizedBox(height: 16),

                  // Payment Type Selection
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
                    height: selectedPayment != null ? null : 0,
                    child: selectedPayment != null
                        ? _buildPaymentDetailsSection(theme, colorScheme)
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom action buttons
          _buildFixedBottomActions(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildGCashProviderCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.withAlpha(128), width: 1.5),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.withAlpha(16), theme.colorScheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/gcash.jpg', // Assuming GCash logo path
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.title('GCash', size: AppTextSize.md),
                  CustomText.body(
                    'Safe and convenient mobile payment',
                    size: AppTextSize.sm,
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    int currentStep = 1;
    if (selectedPayment != null) {
      currentStep = 2;
    }
    if (receiptImage != null &&
        _referenceController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
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
    final provider = context.read<PaymentSettingsProvider>();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withAlpha(64)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Application ID', provider.applicationId, Icons.tag),
          Divider(height: 24, color: colorScheme.outline.withAlpha(64)),
          _buildInfoRow(
            'Total Amount',
            CurrencyUtils.toPHP(provider.amount),
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
        final isSelected = selectedPayment?.id == paymentOption.id;

        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedPayment = paymentOption;
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
                    value: paymentOption.id,
                    groupValue: selectedPayment?.id,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = paymentOption;
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  Icon(
                    paymentOption.icon,
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
                          paymentOption.title,
                          fontWeight: AppFontWeight.bold.value,
                          color: isSelected ? colorScheme.primary : null,
                        ),
                        SizedBox(height: 4),
                        CustomText.body(
                          paymentOption.description,
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
        // Payment Amount Display
        _buildEnhancedSectionCard(
          title: 'Payment Amount',
          icon: Icons.account_balance_wallet_outlined,
          theme: theme,
          isHighlighted: true,
          child: _buildPaymentAmountDisplay(colorScheme),
        ),
        const SizedBox(height: 16),

        // Phone Number Field
        _buildEnhancedSectionCard(
          title: 'GCash Mobile Number',
          icon: Icons.phone_outlined,
          theme: theme,
          child: _buildPhoneField(theme),
        ),
        const SizedBox(height: 16),

        // Reference Number Field
        _buildEnhancedSectionCard(
          title: 'Payment Reference',
          icon: Icons.numbers_outlined,
          theme: theme,
          child: _buildReferenceField(theme),
        ),
        const SizedBox(height: 16),

        // Receipt Upload Section
        _buildEnhancedSectionCard(
          title: 'Upload QR',
          icon: Icons.receipt_long_outlined,
          theme: theme,
          child: _buildEnhancedReceiptUpload(theme),
        ),
        const SizedBox(height: 100), // Space for fixed bottom buttons
      ],
    );
  }

  Widget _buildPaymentAmountDisplay(ColorScheme colorScheme) {
    final provider = context.read<PaymentSettingsProvider>();

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
            CurrencyUtils.toPHP(paymentAmountValue),
            size: AppTextSize.lg,
            color: colorScheme.primary,
          ),
          if (selectedPayment != null && selectedPayment!.percentage < 1.0) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(70),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withAlpha(64)),
              ),
              child: CustomText.body(
                'Remaining: ${CurrencyUtils.toPHP(provider.amount - paymentAmountValue)}',
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

  Widget _buildPhoneField(ThemeData theme) {
    final hasError = _getPhoneValidationError() != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Enter your GCash registered mobile number',
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
                  : _phoneFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withAlpha(64),
              width: 2,
            ),
          ),
          child: TextFormField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            decoration: InputDecoration(
              hintText: 'e.g., 09123456789',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: hasError
                    ? theme.colorScheme.error
                    : _phoneFocusNode.hasFocus
                    ? theme.colorScheme.primary
                    : null,
              ),
              suffixIcon: _phoneController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _phoneController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              errorStyle: TextStyle(height: 0),
            ),
            keyboardType: TextInputType.phone,
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
                _getPhoneValidationError()!,
                size: AppTextSize.xs,
                color: theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildReferenceField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Enter the reference number from your GCash payment receipt',
          size: AppTextSize.sm,
          color: theme.colorScheme.onSurface.withAlpha(160),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _referenceController,
          focusNode: _referenceFocusNode,
          decoration: InputDecoration(
            hintText: 'e.g., REF123456789',
            prefixIcon: Icon(
              Icons.numbers_outlined,
              color: theme.colorScheme.primary,
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
      ],
    );
  }

  Widget _buildEnhancedReceiptUpload(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(
          'Upload a clear photo of your QR code',
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
                    'Tap to upload QR Code',
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
