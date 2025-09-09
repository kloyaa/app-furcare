import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  String get _generateReferenceNumber {
    final now = DateTime.now();
    return 'OTC${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(8)}';
  }

  String get _validUntil {
    final validUntil = DateTime.now().add(Duration(hours: 24));
    return DateTimeUtils.formatDateToShort(validUntil);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.read<PaymentSettingsProvider>();

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
                    _buildPaymentInfoCard(provider, theme),
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

  Widget _buildPaymentInfoCard(
    PaymentSettingsProvider provider,
    ThemeData theme,
  ) {
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
                    CurrencyUtils.toPHP(provider.amount),
                    size: AppTextSize.lg,
                    color: theme.colorScheme.primary,
                    fontWeight: AppFontWeight.black.value,
                  ),
                ],
              ),
            ),

            // Payment Details
            ..._buildPaymentDetailRows(provider, theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPaymentDetailRows(
    PaymentSettingsProvider provider,
    ThemeData theme,
  ) {
    final details = [
      {
        'label': 'Application ID',
        'value': provider.applicationId,
        'icon': Icons.tag,
      },
      {
        'label': 'Reference Number',
        'value': _generateReferenceNumber,
        'icon': Icons.numbers_outlined,
      },
      {'label': 'Valid Until', 'value': _validUntil, 'icon': Icons.schedule},
    ];

    return details.map((detail) {
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
    }).toList();
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
}
