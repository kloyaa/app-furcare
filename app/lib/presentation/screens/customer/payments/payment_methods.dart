import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/payment.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  PaymentMethod? selectedMethod;
  double paymentAmount = 3000.0;
  String applicationId = "9XAFGKFKA0242";

  final List<PaymentMethodInfo> paymentMethods = [
    PaymentMethodInfo(
      id: PaymentMethod.gcash,
      title: 'GCash',
      subtitle: 'Pay using your GCash wallet',
      description: 'Fast and secure digital payment',
      iconAsset: 'assets/gcash.jpg',
      color: Colors.blue,
      processingTime: 'Instant',
      features: ['QR Code Payment', 'Mobile Wallet', 'Instant Transfer'],
    ),
    PaymentMethodInfo(
      id: PaymentMethod.cash,
      title: 'Over The Counter',
      subtitle: 'Pay at authorized payment centers',
      description: 'Cash payment at physical locations',
      icon: Icons.store_outlined,
      color: Colors.orange,
      processingTime: '1-3 Business Days',
      features: ['Cash Payment', '7-Eleven, Bayad Center', 'Physical Receipt'],
    ),
    PaymentMethodInfo(
      id: PaymentMethod.bankTransfer,
      title: 'Bank Transfer',
      subtitle: 'Direct bank to bank transfer',
      description: 'Secure online banking transfer',
      icon: Icons.account_balance_outlined,
      color: Colors.purple,
      processingTime: '1-2 Business Days',
      features: ['Online Banking', 'Bank Transfer', 'Secure Payment'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _navigateToPaymentMethod(PaymentMethod paymentMethod) {
    setState(() {
      selectedMethod = paymentMethod;
    });

    PaymentSettingsProvider provider = context.read<PaymentSettingsProvider>();

    provider.setPaymentMethod(paymentMethod);

    // Add a small delay for visual feedback
    Future.delayed(Duration(milliseconds: 350), () {
      if (mounted) {
        switch (paymentMethod) {
          case PaymentMethod.gcash:
            context.push(CustomerRoute.payment.ewalletGcashPayment);
            break;
          case PaymentMethod.cash:
            context.push(CustomerRoute.payment.otcPayment);
            break;
          case PaymentMethod.bankTransfer:
            context.push(CustomerRoute.payment.bankPayment);
            break;

          default:
            break;
        }
      }
      // Reset selection after navigation
      setState(() {
        selectedMethod = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomListAppBar(title: 'Payment Methods'),
      body: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Payment Summary Header
                  _buildPaymentSummaryHeader(theme),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Methods Grid
                          ...paymentMethods.asMap().entries.map((entry) {
                            final index = entry.key;
                            final method = entry.value;
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              margin: EdgeInsets.only(bottom: 16),
                              child: _buildPaymentMethodCard(
                                method,
                                theme,
                                index * 100, // Staggered animation delay
                              ),
                            );
                          }),

                          const SizedBox(height: 24),

                          // Additional Information Card
                          _buildInfoCard(theme),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentSummaryHeader(ThemeData theme) {
    PaymentSettingsProvider provider = context.read<PaymentSettingsProvider>();
    String applicationId = provider.applicationId;
    String paymentAmount = CurrencyUtils.toPHP(provider.amount);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(32),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
        ),
      ),
      child: Row(
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
                CustomText.body(
                  'Application ID: $applicationId',
                  color: theme.colorScheme.primary,
                  size: AppTextSize.md,
                ),
                CustomText.title(
                  'Amount: $paymentAmount',
                  color: theme.colorScheme.primary,
                  size: AppTextSize.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    PaymentMethodInfo method,
    ThemeData theme,
    int delay,
  ) {
    final isSelected = selectedMethod == method.id;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: InkWell(
        onTap: () => _navigateToPaymentMethod(method.id),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? method.color.withAlpha(128)
                  : theme.colorScheme.outline.withAlpha(64),
              width: isSelected ? 2 : 1,
            ),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      method.color.withAlpha(32),
                      method.color.withAlpha(16),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : theme.colorScheme.surface,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: method.color.withAlpha(32),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withAlpha(16),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icon/Logo Container
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: method.color.withAlpha(32),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: method.color.withAlpha(64),
                          width: 1,
                        ),
                      ),
                      child: method.iconAsset != null
                          ? Padding(
                              padding: EdgeInsets.all(12),
                              child: Image.asset(
                                method.iconAsset!,
                                width: 32,
                                height: 32,
                              ),
                            )
                          : Icon(method.icon, color: method.color, size: 28),
                    ),
                    SizedBox(width: 16),
                    // Method Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomText.title(
                                method.title,
                                size: AppTextSize.md,
                                fontWeight: AppFontWeight.bold.value,
                                color: isSelected ? method.color : null,
                              ),
                              Spacer(),
                              if (isSelected)
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: method.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          CustomText.body(
                            method.subtitle,
                            size: AppTextSize.sm,
                            color: theme.colorScheme.onSurface.withAlpha(160),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: method.color.withAlpha(32),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: method.color.withAlpha(64),
                                  ),
                                ),
                                child: CustomText.body(
                                  method.processingTime,
                                  size: AppTextSize.xs,
                                  color: method.color.withAlpha(200),
                                  fontWeight: AppFontWeight.bold.value,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Features (shown when expanded or selected)
                if (method.features.isNotEmpty) ...[
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withAlpha(32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.features.take(3).map((feature) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: method.color,
                                size: 16,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: CustomText.body(
                                  feature,
                                  size: AppTextSize.xs,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    128,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                CustomText.title(
                  'Payment Information',
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.bold.value,
                ),
              ],
            ),
            SizedBox(height: 12),
            CustomText.body(
              '• All payments are processed securely\n'
              '• You will receive confirmation once payment is verified\n'
              '• Keep your payment receipt for reference\n'
              '• Contact support for any payment issues',
              size: AppTextSize.sm,
              color: theme.colorScheme.onSurface.withAlpha(160),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodInfo {
  final PaymentMethod id;
  final String title;
  final String subtitle;
  final String description;
  final String? iconAsset;
  final IconData? icon;
  final Color color;
  final String processingTime;
  final List<String> features;

  PaymentMethodInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    this.iconAsset,
    this.icon,
    required this.color,
    required this.processingTime,
    this.features = const [],
  });
}
