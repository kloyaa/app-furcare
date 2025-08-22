import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';

class HomeServiceAppointmentScreen extends StatefulWidget {
  const HomeServiceAppointmentScreen({super.key});

  @override
  State<HomeServiceAppointmentScreen> createState() =>
      _HomeServiceAppointmentScreenState();
}

class _HomeServiceAppointmentScreenState
    extends State<HomeServiceAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: "Home Service Appointment",
        titleTextStyle: TextStyle(
          fontSize: AppTextSize.sm.size,
          fontWeight: AppFontWeight.semibold.value,
        ),
      ),
    );
  }
}
