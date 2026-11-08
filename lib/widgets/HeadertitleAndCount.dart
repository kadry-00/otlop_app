import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';

class wHeadertiltleAndCount extends StatelessWidget {
  final String screenTiltle;
  final int countItem;
  final VoidCallback? onBackTap;

  const wHeadertiltleAndCount({
    super.key,
    required this.screenTiltle,
    required this.countItem,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF5F5F5),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: onBackTap ?? () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  screenTiltle,
                  style: Appstyle.font18withbold.copyWith(fontSize: 20),
                ),
                Text(
                  "$countItem items",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
