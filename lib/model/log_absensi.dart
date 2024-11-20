class LogAbsensi {
  final String type; // 'Clock In', 'Clock Out', 'Izin', 'Cuti', 'Lembur'
  final DateTime timestamp;
  final String status; // 'Pending', 'Approved', 'Rejected'

  LogAbsensi({
    required this.type,
    required this.timestamp,
    required this.status,
  });
}
