import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class clsFilterHeader extends StatelessWidget {
  final String title;
  final String searchHint;
  final int itemsCount;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;

  const clsFilterHeader({
    super.key,
    required this.title,
    required this.itemsCount,
    this.searchHint = "Search products...",
    this.onSearchChanged,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: Appstyle.font18withbold.copyWith(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: searchHint,
                    hintStyle: Appstyle.font14withSemiBold.copyWith(
                      color: Colors.grey.shade400,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: searchController != null && searchController!.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () {
                              searchController!.clear();
                              if (onSearchChanged != null) onSearchChanged!("");
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Appstyle.MainColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.filter_alt_outlined, color: Colors.white, size: 22),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          "$itemsCount items available",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
