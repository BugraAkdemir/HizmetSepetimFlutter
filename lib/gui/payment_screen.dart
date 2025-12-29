import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../appData/api_service.dart';
import '../../theme/colors.dart';
import 'widgets/payment_addons.dart';
import 'widgets/payment_datetime.dart';
import 'widgets/payment_wallet.dart';

class PaymentScreen extends StatefulWidget {
  final String productName;
  final double price;
  final int categoryId;
  final int addressId;

  const PaymentScreen({
    super.key,
    required this.productName,
    required this.price,
    required this.categoryId,
    required this.addressId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ApiService api = ApiService();

  List<Map<String, dynamic>> addons = [];
  final Set<int> selectedAddons = {};

  DateTime? selectedDateTime;

  final cardHolder = TextEditingController();
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadAddons();
  }

  Future<void> _loadAddons() async {
    final list = await api.getAddons();
    if (!mounted) return;
    setState(() => addons = list);
  }

  double get totalPrice {
    double total = widget.price;
    for (final a in addons) {
      if (selectedAddons.contains(a["id"])) {
        total += (a["price"] as num).toDouble();
      }
    }
    return total;
  }

  String get addonsPayload {
    if (selectedAddons.isEmpty) return "";
    final list = selectedAddons.toList()..sort();
    return list.join(',');
  }

  String get appointmentPayload {
    if (selectedDateTime == null) return "";
    final d = selectedDateTime!;
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} "
        "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: textDark,
        title: const Text("Ödeme"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _orderSummary(),
          const SizedBox(height: 16),

          PaymentAddons(
            addons: addons,
            selected: selectedAddons,
            onChanged: (id, v) {
              setState(() {
                v ? selectedAddons.add(id) : selectedAddons.remove(id);
              });
            },
          ),
          const SizedBox(height: 16),

          PaymentDateTime(
            value: selectedDateTime,
            onChanged: (dt) => setState(() => selectedDateTime = dt),
          ),
          const SizedBox(height: 16),

          const PaymentWallet(balance: 0, enabled: false),
          const SizedBox(height: 16),

          _cardForm(),
          const SizedBox(height: 24),

          _payButton(),
        ],
      ),
    );
  }

  Widget _orderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sipariş Özeti",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          _row("Ürün", widget.productName),
          _row("Adres ID", widget.addressId.toString()),
          const Divider(height: 24),
          _row("Toplam", "₺${totalPrice.toStringAsFixed(2)}", bold: true),
        ],
      ),
    );
  }

  Widget _cardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kart Bilgileri (Opsiyonel)",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),

          _input(cardHolder, "Kart Üzerindeki İsim", Icons.person),

          _input(
            cardNumber,
            "Kart Numarası",
            Icons.credit_card,
            keyboard: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberFormatter(),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: _input(
                  expiry,
                  "AA/YY",
                  Icons.date_range,
                  keyboard: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    ExpiryDateFormatter(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _input(
                  cvv,
                  "CVV",
                  Icons.lock,
                  keyboard: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text(
            "Kart bilgileri şu an sadece görsel amaçlıdır.",
            style: TextStyle(fontSize: 12, color: textSoft),
          ),
        ],
      ),
    );
  }

  Widget _payButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: loading ? null : _pay,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Ödemeyi Tamamla • ₺${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _pay() async {
    setState(() => loading = true);

    final ok = await api.createOrder(
      addressId: widget.addressId,
      productName: widget.productName,
      price: widget.price,
      totalPrice: totalPrice,
      appointment: appointmentPayload,
      addons: addonsPayload,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ok
        ? _showSuccess()
        : ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sipariş oluşturulamadı")),
          );
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "Sipariş Başarılı 🎉",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Tamam"),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBox() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  Widget _row(String l, String r, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: textSoft)),
      Text(
        r,
        style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500),
      ),
    ],
  );

  Widget _input(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 4) text = text.substring(0, 4);

    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
