import 'colorModel.dart';
import 'itemModel.dart';

class ShoppingListModel {
  const ShoppingListModel({
    required this.id,
    required this.name,
    required this.color,
    this.items

  });

  final String id;
  final String name;
  final ColorModel color;
  final List<ItemModel>? items;
}