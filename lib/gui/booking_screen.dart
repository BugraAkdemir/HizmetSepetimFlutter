import 'dart:convert';
import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../theme/colors.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService api = ApiService();
  List<Booking> bookings = [];
  bool loading = true;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    setState(() {
      loading = true;
      errorText = null;
    });

    try {
      final list = await api.getBookings();

      if (!mounted) return;
      setState(() {
        bookings = list;
        loading = false;
      });
    } catch (e) {
      debugPrint("BOOKING LOAD ERROR => $e");

      if (!mounted) return;
      setState(() {
        loading = false;
        errorText = "Randevular alınamadı. Lütfen tekrar deneyin.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator(color: primary));
    }

    if (errorText != null) {
      return Material(
        color: bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 44, color: primary),
                const SizedBox(height: 10),
                Text(
                  errorText!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: textSoft, fontSize: 14),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _loadBookings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Yeniden Dene",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: bg,
      child: RefreshIndicator(
        onRefresh: _loadBookings,
        color: primary,
        child: bookings.isEmpty
            ? _emptyState()
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),
                itemCount: bookings.length,
                itemBuilder: (context, index) => _bookingCard(bookings[index]),
              ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: primary.withOpacity(0.5),
              ),
              const SizedBox(height: 20),
              const Text(
                "Henüz randevunuz yok",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Yeni bir hizmet satın aldığınızda\nrandevularınız burada görünecek",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: textSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(booking.appointmentDatetime),
                        style: const TextStyle(fontSize: 14, color: textSoft),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(booking.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (booking.addressLine != null || booking.city != null)
                  _infoRow(
                    Icons.location_on,
                    "${booking.addressLine ?? ''}, ${booking.district ?? ''}, ${booking.city ?? ''}",
                  ),

                if (booking.addressLine != null || booking.city != null)
                  const SizedBox(height: 12),

                if (booking.addons != null && booking.addons!.isNotEmpty)
                  _addonsSection(booking.addons!),

                if (booking.addons != null && booking.addons!.isNotEmpty)
                  const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Toplam Tutar",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSoft,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₺${booking.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.3),
                      disabledBackgroundColor: Colors.redAccent.withOpacity(
                        0.3,
                      ),
                      disabledForegroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Randevuyu İptal Et",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: textSoft),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: textDark),
          ),
        ),
      ],
    );
  }

  Widget _addonsSection(String addonsString) {
    final trimmed = addonsString.trim();
    if (trimmed.isEmpty) return const SizedBox.shrink();

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List && decoded.isNotEmpty) {
        final addonsList = decoded
            .map((e) {
              if (e is Map) {
                return e['name']?.toString() ?? e.toString();
              }
              return e.toString();
            })
            .where((e) => e.isNotEmpty)
            .toList();

        if (addonsList.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle_outline, size: 18, color: textSoft),
                  const SizedBox(width: 8),
                  const Text(
                    "Ek Hizmetler:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...addonsList.map(
                (addon) => Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          addon,
                          style: const TextStyle(fontSize: 14, color: textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }
    } catch (_) {}

    if (trimmed.contains(',')) {
      final addonsList = trimmed
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (addonsList.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, size: 18, color: textSoft),
                const SizedBox(width: 8),
                const Text(
                  "Ek Hizmetler:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...addonsList.map(
              (addon) => Padding(
                padding: const EdgeInsets.only(left: 26, bottom: 4),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        addon,
                        style: const TextStyle(fontSize: 14, color: textDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    return _infoRow(Icons.add_circle_outline, "Ek Hizmetler: $trimmed");
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'TAMAMLANDI':
        return const Color(0xFF52B788);
      case 'CANCELLED':
      case 'IPTAL':
        return Colors.redAccent;
      case 'CONFIRMED':
      case 'ONAYLANDI':
        return primary;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Beklemede';
      case 'CONFIRMED':
      case 'ONAYLANDI':
        return 'Onaylandı';
      case 'COMPLETED':
      case 'TAMAMLANDI':
        return 'Tamamlandı';
      case 'CANCELLED':
      case 'IPTAL':
        return 'İptal';
      default:
        return status;
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year;
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      return "$day.$month.$year $hour:$minute";
    } catch (e) {
      return dateTimeString;
    }
  }
}
