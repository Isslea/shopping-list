
class ItemModel {
  ItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    this.isDone = false
  });

  final String id;
  final String name;
  final int quantity;
  bool isDone;
}