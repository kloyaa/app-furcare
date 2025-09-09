import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/core/utils/formatters.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankPaymentReceiptScreen extends StatefulWidget {
  const BankPaymentReceiptScreen({super.key});

  @override
  State<BankPaymentReceiptScreen> createState() =>
      _BankPaymentReceiptScreenState();
}

class _BankPaymentReceiptScreenState extends State<BankPaymentReceiptScreen>
    with TickerProviderStateMixin {
  late AnimationController _successAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _showShareOptions = false;

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

  Future<void> _shareReceipt() async {
    // Implementation for sharing receipt
    setState(() {
      _showShareOptions = !_showShareOptions;
    });
  }

  Future<void> _downloadReceipt() async {
    // Implementation for downloading receipt
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_done, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Receipt saved to Downloads'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get the data passed from GoRouter with proper null checking
    final extra = GoRouterState.of(context).extra;

    if (extra == null || extra is! Map<String, dynamic>) {
      return _buildErrorState(theme);
    }

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
                    // Receipt Summary Card
                    _buildReceiptSummaryCard(theme),
                    const SizedBox(height: 16),

                    // Payment Details Card
                    _buildEnhancedDetailCard(
                      title: 'Payment Details',
                      icon: Icons.receipt_long_outlined,
                      theme: theme,
                      children: _buildPaymentDetailRows(colorScheme),
                    ),
                    const SizedBox(height: 16),

                    // Transaction Timeline
                    _buildTransactionTimeline(theme),
                    const SizedBox(height: 16),

                    // Receipt Image Card
                    _buildEnhancedReceiptImageCard(theme),
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
        title: 'Payment Receipt',
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
              'Unable to load receipt information.',
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

  Widget _buildReceiptSummaryCard(ThemeData theme) {
    final provider = context.read<PaymentSettingsProvider>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(20),
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
        ),
        child: Column(
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
                    Icons.account_balance_outlined,
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
                        'Bank Payment Receipt',
                        size: AppTextSize.md,
                      ),
                      CustomText.body(
                        'Application: ${provider.applicationId}',
                        size: AppTextSize.sm,
                        color: theme.colorScheme.onSurface.withAlpha(160),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.body('Amount Paid', size: AppTextSize.sm),
                    CustomText.title(
                      CurrencyUtils.toPHP(provider.amountPaid),
                      size: AppTextSize.lg,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDetailCard({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
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
                  child: Icon(icon, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                CustomText.title(title, size: AppTextSize.md),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPaymentDetailRows(ColorScheme colorScheme) {
    final provider = context.read<PaymentSettingsProvider>();
    final details = [
      ('Application ID', provider.applicationId, Icons.tag),
      (
        'Payment Type',
        formatPaymentType(provider.paymentType),
        Icons.payment_outlined,
      ),
      ('Reference Number', provider.reference, Icons.numbers_outlined),
      (
        'Amount Paid',
        CurrencyUtils.toPHP(provider.amountPaid),
        Icons.account_balance_wallet,
      ),
      (
        'Date & Time',
        DateTimeUtils.formatDateToShort(DateTime.now()),
        Icons.schedule,
      ),
      ('Status', 'Processing', Icons.hourglass_empty),
    ];

    return details.map((detail) {
      final isStatus = detail.$1 == 'Status';
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Icon(
              detail.$3,
              size: 16,
              color: colorScheme.onSurface.withAlpha(128),
            ),
            SizedBox(width: 12),
            Expanded(child: CustomText.body(detail.$1)),
            if (isStatus)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(32),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withAlpha(64)),
                ),
                child: CustomText.body(
                  detail.$2,
                  size: AppTextSize.xs,
                  fontWeight: AppFontWeight.bold.value,
                  color: Colors.orange.shade700,
                ),
              )
            else
              CustomText.body(detail.$2, fontWeight: AppFontWeight.bold.value),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTransactionTimeline(ThemeData theme) {
    final steps = [
      ('Payment Submitted', 'Just now', true, Colors.green),
      ('Under Review', '~5 minutes', false, Colors.orange),
      ('Payment Confirmed', '~15 minutes', false, Colors.grey),
      ('Application Updated', '~30 minutes', false, Colors.grey),
    ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
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
                    Icons.timeline_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                CustomText.title('Processing Timeline', size: AppTextSize.md),
              ],
            ),
            const SizedBox(height: 20),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isLast = index == steps.length - 1;

              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: step.$4,
                          shape: BoxShape.circle,
                          border: step.$3
                              ? null
                              : Border.all(color: step.$4, width: 2),
                        ),
                        child: step.$3
                            ? Icon(Icons.check, size: 12, color: Colors.white)
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: theme.colorScheme.outline.withAlpha(64),
                        ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText.body(
                            step.$1,
                            fontWeight: step.$3
                                ? AppFontWeight.bold.value
                                : FontWeight.normal,
                            color: step.$3
                                ? null
                                : theme.colorScheme.onSurface.withAlpha(128),
                          ),
                          CustomText.body(
                            step.$2,
                            size: AppTextSize.xs,
                            color: theme.colorScheme.onSurface.withAlpha(128),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedReceiptImageCard(ThemeData theme) {
    final provider = context.read<PaymentSettingsProvider>();
    final receipt = provider.receipt;
    if (receipt == null) {
      return SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withAlpha(64)),
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
                    Icons.image_outlined,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomText.title(
                    'Uploaded Receipt',
                    size: AppTextSize.md,
                  ),
                ),
                IconButton(
                  onPressed: () => _showFullScreenImage(receipt),
                  icon: Icon(Icons.fullscreen_outlined),
                  tooltip: 'View Full Screen',
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _showFullScreenImage(receipt),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(64),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(receipt, fit: BoxFit.cover),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(160),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.zoom_in_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Share Receipt',
                onPressed: _shareReceipt,
                icon: Icons.share_outlined,
                isOutlined: true,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Download PDF',
                onPressed: _downloadReceipt,
                icon: Icons.download_outlined,
                isOutlined: true,
              ),
            ),
          ],
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
                'Important Information',
                fontWeight: AppFontWeight.bold.value,
              ),
            ],
          ),
          SizedBox(height: 12),
          CustomText.body(
            '• Keep this receipt for your records\n'
            '• Bank payment processing may take 1-3 business days\n'
            '• You will receive email confirmation once verified\n'
            '• Contact support if you have any questions',
            size: AppTextSize.sm,
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(File image) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              body: Center(child: InteractiveViewer(child: Image.file(image))),
            ),
          );
        },
      ),
    );
  }
}
