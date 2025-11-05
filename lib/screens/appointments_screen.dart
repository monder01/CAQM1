import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../theme.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  // إضافة أو تعديل موعد
  void _showAppointmentDialog({String? id, String? doctor, String? date, String? time}) async {
    String? selectedDoctor = doctor;
    DateTime? selectedDate = date != null ? DateTime.parse(date) : null;
    TimeOfDay? selectedTime;

    if (time != null) {
      final timeParts = time.split(':');
      if (timeParts.length >= 2) {
        selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1].split(' ')[0]),
        );
      }
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(id == null ? 'Add Appointment' : 'Edit Appointment'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: selectedDoctor,
                      decoration: const InputDecoration(labelText: 'Select Doctor'),
                      items: const [
                        DropdownMenuItem(value: 'Dr. Ali', child: Text('Dr. Ali')),
                        DropdownMenuItem(value: 'Dr. Sara', child: Text('Dr. Sara')),
                        DropdownMenuItem(value: 'Dr. Omar', child: Text('Dr. Omar')),
                      ],
                      onChanged: (value) => setState(() => selectedDoctor = value),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                        );
                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                      child: Text(selectedDate == null
                          ? 'Pick Date'
                          : 'Date: ${DateFormat('EEEE, dd MMM yyyy').format(selectedDate!)}'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() => selectedTime = pickedTime);
                        }
                      },
                      child: Text(selectedTime == null
                          ? 'Pick Time'
                          : 'Time: ${selectedTime!.format(context)}'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDoctor != null &&
                        selectedDate != null &&
                        selectedTime != null) {
                      final appointmentData = {
                        'doctor': selectedDoctor,
                        'date': selectedDate!.toIso8601String(),
                        'time': selectedTime!.format(context),
                      };
                      if (id == null) {
                        await appointments.add(appointmentData);
                      } else {
                        await appointments.doc(id).update(appointmentData);
                      }
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // حذف الموعد من Firestore
  Future<void> _deleteAppointment(String id) async {
    await appointments.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: appointments.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading appointments'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No appointments yet'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final doctor = doc['doctor'] ?? 'Unknown';
              final dateStr = doc['date'] ?? '';
              final timeStr = doc['time'] ?? '';

              DateTime? parsedDate;
              try {
                parsedDate = DateTime.parse(dateStr);
              } catch (e) {
                parsedDate = null;
              }

              String formattedDate = 'Unknown Date';
              if (parsedDate != null) {
                formattedDate = DateFormat('EEEE, dd MMM yyyy').format(parsedDate);
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  title: Text(
                    doctor,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('$formattedDate — $timeStr'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAppointmentDialog(
                          id: doc.id,
                          doctor: doc['doctor'],
                          date: doc['date'],
                          time: doc['time'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAppointment(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => _showAppointmentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
