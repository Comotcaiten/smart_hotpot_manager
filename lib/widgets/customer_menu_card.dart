// lib/widgets/customer_menu_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_hotpot_manager/models/product.dart';
import 'package:smart_hotpot_manager/services/cart_service.dart';

class CustomerMenuItemCard extends StatelessWidget {
  final Product product;
  const CustomerMenuItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Card(
      elevation: 2,
      shadowColor: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl.isNotEmpty 
              ? product.imageUrl 
              : 'https://via.placeholder.com/350x120.png?text=No+Image', 
            height: 120, 
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 120,
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const Spacer(), // Đẩy phần giá tiền xuống dưới

          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currencyFormat.format(product.price),
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    cart.addItem(product);
                    
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm ${product.name} vào giỏ!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Thêm'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor, 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
}