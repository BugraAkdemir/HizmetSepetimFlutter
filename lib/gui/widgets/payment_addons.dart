import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class PaymentAddons extends StatelessWidget {
  final List<Map<String, dynamic>> addons;
  final Set<int> selected;
  final void Function(int id, bool value) onChanged;

  const PaymentAddons({
    super.key,
    required this.addons,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ek Hizmetler",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...addons.map((a) {
            return CheckboxListTile(
              value: selected.contains(a["id"]),
              onChanged: (v) => onChanged(a["id"], v ?? false),
              title: Text(a["name"]),
              subtitle: Text("+₺${a["price"]}"),
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
