import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OTCPaymentReceiptScreen extends StatefulWidget {
  const OTCPaymentReceiptScreen({super.key});

  @override
  State<OTCPaymentReceiptScreen> createState() =>
      _OTCPaymentReceiptScreenState();
}

class _OTCPaymentReceiptScreenState extends State<OTCPaymentReceiptScreen>
    with TickerProviderStateMixin {
  late AnimationController _successAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _successAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _successAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOut),
    );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _successAnimationController.forward();
      Future.delayed(Duration(milliseconds: 300), () {
        _slideAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _successAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get the data passed from GoRouter with proper null checking
    // final extra = GoRouterState.of(context).extra;

    // Mock data for testing - remove this when using real navigation
    final extra = {
      'paymentType': 'Full Payment',
      'paymentAmount': 3000.0,
      'applicationId': '9XAFGKFKA0242',
    };
    // ignore: unnecessary_null_comparison, unnecessary_type_check
    if (extra == null || extra is! Map<String, dynamic>) {
      return _buildErrorState(theme);
    }

    final Map<String, dynamic> paymentData = extra;
    final receiptData = _extractReceiptData(paymentData);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Animated Success Header
                    _buildAnimatedSuccessHeader(colorScheme),
                    const SizedBox(height: 24),

                    // Payment Information Card
                    _buildPaymentInfoCard(receiptData, theme),
                    const SizedBox(height: 16),

                    // Counter Instructions Card
                    _buildCounterInstructionsCard(theme),
                    const SizedBox(height: 24),

                    // Action Buttons
                    _buildActionButtonsSection(theme, colorScheme),

                    // Additional Info
                    _buildAdditionalInfo(theme),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment Instructions',
        titleTextStyle: TextStyle(
          fontSize: AppTextSize.md.size,
          fontWeight: AppFontWeight.black.value,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            SizedBox(height: 16),
            CustomText.title('No Payment Data Found'),
            SizedBox(height: 8),
            CustomText.body(
              'Unable to load payment information.',
              color: theme.colorScheme.onSurface.withAlpha(160),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Go Home',
              onPressed: () => context.go(CustomerRoute.home),
              icon: Icons.home_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSuccessHeader(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _successAnimation.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade50,
                  Colors.orange.shade100.withAlpha(128),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withAlpha(32),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withAlpha(64),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                CustomText.title(
                  'Payment Pending',
                  color: Colors.orange.shade800,
                  size: AppTextSize.lg,
                  textAlign: TextAlign.center,
                  fontWeight: AppFontWeight.bold.value,
                ),
                const SizedBox(height: 8),
                CustomText.body(
                  'Present this information at the payment counter',
                  color: Colors.orange.shade700,
                  size: AppTextSize.sm,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentInfoCard(ReceiptData receiptData, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withAlpha(16),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: theme.colorScheme.primary.withAlpha(64),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(32),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.title(
                        'Payment Information',
                        size: AppTextSize.md,
                      ),
                      CustomText.body(
                        'Show this to the cashier',
                        size: AppTextSize.sm,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Amount Display - Prominent
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withAlpha(32),
                    theme.colorScheme.primaryContainer.withAlpha(16),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withAlpha(64),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.payments_rounded,
                    color: theme.colorScheme.primary,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  CustomText.body(
                    'Amount to Pay',
                    color: theme.colorScheme.onSurface.withAlpha(160),
                  ),
                  const SizedBox(height: 8),
                  CustomText.title(
                    formatToPhpCurrency(receiptData.paymentAmount),
                    size: AppTextSize.lg,
                    color: theme.colorScheme.primary,
                    fontWeight: AppFontWeight.black.value,
                  ),
                ],
              ),
            ),

            // Payment Details
            ...receiptData.getPaymentDetails().map((detail) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Icon(
                      detail['icon'] as IconData,
                      size: 18,
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomText.body(
                        detail['label'] as String,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                    ),
                    Expanded(
                      child: CustomText.body(
                        detail['value'] as String,
                        fontWeight: AppFontWeight.bold.value,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterInstructionsCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange.withAlpha(128)),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.orange.withAlpha(16), theme.colorScheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(32),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                CustomText.title('Payment Instructions', size: AppTextSize.md),
              ],
            ),
            const SizedBox(height: 16),
            _buildInstructionStep(
              '1',
              'Visit any authorized payment center',
              Icons.location_on_outlined,
              theme,
            ),
            _buildInstructionStep(
              '2',
              'Present this screen to the cashier',
              Icons.phone_android_outlined,
              theme,
            ),
            _buildInstructionStep(
              '3',
              'Pay the exact amount shown above',
              Icons.payment_outlined,
              theme,
            ),
            _buildInstructionStep(
              '4',
              'Keep your official receipt',
              Icons.receipt_outlined,
              theme,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
    String stepNumber,
    String instruction,
    IconData icon,
    ThemeData theme, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomText.body(
                stepNumber,
                color: Colors.white,
                size: AppTextSize.xs,
                fontWeight: AppFontWeight.bold.value,
              ),
            ),
          ),
          SizedBox(width: 12),
          Icon(icon, size: 20, color: Colors.orange.shade700),
          SizedBox(width: 12),
          Expanded(
            child: CustomText.body(
              instruction,
              fontWeight: AppFontWeight.semibold.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        CustomButton(
          text: 'Done',
          onPressed: () => context.go(CustomerRoute.home),
          icon: Icons.home_outlined,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Take Screenshot',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Take a screenshot of this page for reference'),
                  ],
                ),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: Icons.camera_alt_outlined,
          isOutlined: true,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(ThemeData theme) {
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(64),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
              SizedBox(width: 8),
              CustomText.body(
                'Important Reminders',
                fontWeight: AppFontWeight.bold.value,
              ),
            ],
          ),
          SizedBox(height: 12),
          CustomText.body(
            '• Payment must be made within 24 hours\n'
            '• Bring a valid ID when paying at the counter\n'
            '• Keep your official receipt for verification\n'
            '• Contact support if you encounter any issues',
            size: AppTextSize.sm,
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ],
      ),
    );
  }

  ReceiptData _extractReceiptData(Map<String, dynamic> paymentData) {
    return ReceiptData(
      paymentType: paymentData['paymentType'] as String? ?? 'Unknown',
      paymentAmount: paymentData['paymentAmount'] as double? ?? 0.0,
      applicationId: paymentData['applicationId'] as String? ?? 'N/A',
    );
  }
}

class ReceiptData {
  final String paymentType;
  final double paymentAmount;
  final String applicationId;

  ReceiptData({
    required this.paymentType,
    required this.paymentAmount,
    required this.applicationId,
  });

  String get formattedDateTime {
    final now = DateTime.now();
    final formatter = DateFormat('MMM dd, yyyy • hh:mm a');
    return formatter.format(now);
  }

  String get referenceNumber {
    // Generate a simple reference number for OTC payment
    final now = DateTime.now();
    return 'OTC${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  List<Map<String, dynamic>> getPaymentDetails() {
    return [
      {'label': 'Application ID', 'value': applicationId, 'icon': Icons.tag},
      {
        'label': 'Payment Type',
        'value': paymentType,
        'icon': Icons.payment_outlined,
      },
      {
        'label': 'Reference Number',
        'value': referenceNumber,
        'icon': Icons.numbers_outlined,
      },
      {
        'label': 'Valid Until',
        'value': DateFormat(
          'MMM dd, yyyy • hh:mm a',
        ).format(DateTime.now().add(Duration(hours: 24))),
        'icon': Icons.schedule,
      },
    ];
  }
}
