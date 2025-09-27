import 'package:flutter/material.dart';
import 'package:furcare_app/data/models/__staff/appointments_model.dart';
import 'package:furcare_app/presentation/providers/staff/appointment_provider.dart';
import 'package:provider/provider.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  final int _limit = 10;
  int _groomingPage = 1;
  int _boardingPage = 1;
  int _homeServicePage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchCustomerAppointments();
    });
  }

  fetchCustomerAppointments() {
    context.read<StaffAppointmentProvider>().getCustomerAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<StaffAppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.customerAppointments == null &&
              provider.isFetchingAppointments) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.customerAppointments == null) {
            return const Center(child: Text("No data available"));
          }

          final appointments = provider.customerAppointments!.appointments;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCategory(
                  theme,
                  "Grooming",
                  appointments
                      .where(
                        (a) => a.applicationType.toLowerCase() == "grooming",
                      )
                      .toList(),
                  _groomingPage,
                  (page) => setState(() => _groomingPage = page),
                ),
                _buildCategory(
                  theme,
                  "Boarding",
                  appointments
                      .where(
                        (a) => a.applicationType.toLowerCase() == "boarding",
                      )
                      .toList(),
                  _boardingPage,
                  (page) => setState(() => _boardingPage = page),
                ),
                _buildCategory(
                  theme,
                  "Home Service",
                  appointments
                      .where(
                        (a) => a.applicationType.toLowerCase() == "homeservice",
                      )
                      .toList(),
                  _homeServicePage,
                  (page) => setState(() => _homeServicePage = page),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategory(
    ThemeData theme,
    String title,
    List<CustomerAppointment> appointments,
    int currentPage,
    ValueChanged<int> onPageChanged,
  ) {
    final startIndex = (currentPage - 1) * _limit;
    final endIndex = (startIndex + _limit).clamp(0, appointments.length);
    final pageItems = appointments.sublist(startIndex, endIndex);

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (pageItems.isEmpty)
              const Center(child: Text("No records"))
            else
              Column(
                children: pageItems
                    .map(
                      (appointment) =>
                          _buildAppointmentCard(theme, appointment),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => onPageChanged(currentPage - 1)
                      : null,
                  child: const Text("Previous"),
                ),
                Text("Page $currentPage"),
                ElevatedButton(
                  onPressed: endIndex < appointments.length
                      ? () => onPageChanged(currentPage + 1)
                      : null,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    ThemeData theme,
    CustomerAppointment appointment,
  ) {
    // simplified: reuse your StaffHomeScreen _buildAppointmentCard logic here
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withAlpha(32),
        child: Icon(Icons.pets, color: theme.colorScheme.primary),
      ),
      title: Text(
        "${appointment.userInfo.fullName} - ${appointment.petInfo.name}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${appointment.applicationType.toUpperCase()} • ${appointment.status}",
      ),
      trailing: Text(
        appointment.submittedAt.split('T')[0],
        style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(160)),
      ),
    );
  }
}
