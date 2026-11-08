import 'package:flutter/material.dart';
import 'package:otlop_1/AppStyle.dart';
import 'package:otlop_1/models/product_model.dart';
import 'package:otlop_1/widgets/add_to_cart.dart';
import 'package:otlop_1/screens/MainNavigationScreen.dart';

class clsTagChip extends StatelessWidget {
  final String label;
  final bool isMain;

  const clsTagChip({super.key, required this.label, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isMain ? Appstyle.secondary : const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isMain ? Appstyle.MainColor : Colors.black54,
        ),
      ),
    );
  }
}

class clsQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const clsQuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onRemove,
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFF3F3F3),
              child: Icon(Icons.remove, size: 18, color: Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "$quantity",
              style: Appstyle.font18withbold.copyWith(fontSize: 16),
            ),
          ),
          InkWell(
            onTap: onAdd,
            customBorder: const CircleBorder(),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Appstyle.MainColor,
              child: Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class clsProductDetails extends StatefulWidget {
  final ProductModel product;

  const clsProductDetails({
    super.key,
    required this.product,
  });

  @override
  State<clsProductDetails> createState() => _clsProductDetailsState();
}

class _clsProductDetailsState extends State<clsProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.45;
    final double topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Container(
              color: const Color(0xFFF8F8F8),
              child: Image.network(
                widget.product.pictureUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.fastfood, size: 64, color: Colors.black26),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: imageHeight - 32),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - imageHeight + 32,
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (widget.product.brand.isNotEmpty)
                        clsTagChip(label: widget.product.brand, isMain: true),
                      const SizedBox(width: 8),
                      if (widget.product.category.isNotEmpty)
                        clsTagChip(label: widget.product.category, isMain: false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.name,
                    style: Appstyle.MainTitle24WithBold.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${widget.product.price.toStringAsFixed(widget.product.price.truncateToDouble() == widget.product.price ? 0 : 2)}",
                        style: Appstyle.MainTitle24WithBold.copyWith(
                          fontSize: 28,
                          color: Appstyle.MainColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "EGP",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 14),
                  const Text(
                    "ABOUT THIS ITEM",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description.isNotEmpty
                        ? widget.product.description
                        : "Delicious and freshly prepared with the highest quality ingredients. Perfect choice for any meal.",
                    style: Appstyle.font14withSemiBold.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: topInset + 10,
            left: 20,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white.withOpacity(0.9),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: [
              clsQuantitySelector(
                quantity: quantity,
                onAdd: () => setState(() => quantity++),
                onRemove: () {
                  if (quantity > 1) {
                    setState(() => quantity--);
                  }
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appstyle.MainColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      addToCart(
                        context,
                        widget.product.id,
                        quantity: quantity,
                      );
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Add to cart  •  ${(widget.product.price * quantity).toStringAsFixed(0)} EGP",
                        style: Appstyle.font17withSemiBold.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
