import 'package:flutter/material.dart';
import '../appData/api_service.dart';
import '../theme/colors.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String name;
  final double price;
  final int categoryId;

  const CheckoutScreen({
    super.key,
    required this.name,
    required this.price,
    required this.categoryId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ApiService api = ApiService();

  List<Address> addresses = [];
  Address? selectedAddress;
  bool loading = true;
  bool showAddDialog = false;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => loading = true);
    try {
      final list = await api.getAddresses();
      addresses = list;
      if (addresses.isNotEmpty) {
        selectedAddress = addresses.first;
      }
    } catch (_) {
      addresses = [];
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: textDark,
        title: const Text("Satın Al • Adres Seç"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sipariş Özeti",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: textDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.name),
                            Text(
                              "₺${widget.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Adres Seç",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => showAddDialog = true),
                        child: const Text("Yeni Adres Ekle"),
                      ),
                    ],
                  ),

                  Expanded(
                    child: addresses.isEmpty
                        ? const Center(
                            child: Text(
                              "Kayıtlı adres bulunamadı",
                              style: TextStyle(color: textSoft),
                            ),
                          )
                        : ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (_, i) {
                              final addr = addresses[i];
                              final selected = selectedAddress?.id == addr.id;

                              return GestureDetector(
                                onTap: () =>
                                    setState(() => selectedAddress = addr),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? primary.withOpacity(0.08)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selected
                                          ? primary
                                          : Colors.grey.shade300,
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Radio(
                                        value: addr.id,
                                        groupValue: selectedAddress?.id,
                                        onChanged: (_) => setState(
                                          () => selectedAddress = addr,
                                        ),
                                        activeColor: primary,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              addr.fullName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${addr.addressLine}, ${addr.district}, ${addr.city}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: textSoft,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              addr.phone,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: textSoft,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: selectedAddress == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    productName: widget.name,
                                    price: widget.price,
                                    categoryId: widget.categoryId,
                                    addressId:
                                        selectedAddress!.id,
                                  ),
                                ),
                              );
                            },
                      child: const Text(
                        "Devam Et",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

      floatingActionButton: showAddDialog
          ? AddAddressDialog(
              onClose: () => setState(() => showAddDialog = false),
              onSaved: () async {
                setState(() => showAddDialog = false);
                await _loadAddresses();
              },
            )
          : null,
    );
  }
}

class AddAddressDialog extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onSaved;

  const AddAddressDialog({
    super.key,
    required this.onClose,
    required this.onSaved,
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final ApiService api = ApiService();

  final fullName = TextEditingController();
  final phone = TextEditingController();
  final line = TextEditingController();
  final district = TextEditingController();
  final city = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: primary),
                SizedBox(width: 8),
                Text(
                  "Yeni Adres",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _field(fullName, "Ad Soyad", Icons.person),
            _field(phone, "Telefon", Icons.phone),
            _field(line, "Açık Adres", Icons.home),
            _field(district, "İlçe", Icons.map),
            _field(city, "Şehir", Icons.location_city),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onClose,
                    child: const Text("İptal"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Kaydet",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (fullName.text.isEmpty ||
        phone.text.isEmpty ||
        line.text.isEmpty ||
        district.text.isEmpty ||
        city.text.isEmpty) {
      return;
    }

    setState(() => loading = true);

    final ok = await api.addAddress(
      fullName: fullName.text,
      phone: phone.text,
      addressLine: line.text,
      district: district.text,
      city: city.text,
    );

    setState(() => loading = false);

    if (!mounted) return;

    if (ok) {
      widget.onSaved();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Adres kaydedilemedi")));
    }
  }

  Widget _field(TextEditingController c, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
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
}
