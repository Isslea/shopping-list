import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lol/models/itemModel.dart';
import 'package:lol/widgets/edit_list.dart';
import 'package:lol/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../models/colorModel.dart';

class ItemList extends StatefulWidget {
  final String id;
  final String name;
  final ColorModel color;
  final Function refreshData;

  const ItemList({Key? key, required this.id, required this.name, required this.color, required this.refreshData}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemModel> _items = [];
  bool showItems = true;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  void _loadLists() async {
    final url = Uri.https(
        'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
        'lists/${widget.id}/items.json');
    final response = await http.get(url);
    final Map<String, dynamic>? listData = json.decode(response.body);
    List<ItemModel> _loadedItems = [];
    if (listData != null) {
      for (final item in listData.entries) {
        _loadedItems.add(
          ItemModel(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              isDone: item.value['isDone']
          ),
        );
      }
    }
    setState(() {
      _items = _loadedItems;
    });

  }


  void _addItem() async {
    await Navigator.of(context).push<ItemModel>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(listId: widget.id, listColorCode: widget.color.colorCode),
      ),
    );

    _loadLists();
  }

  void _editList() async {
    await Navigator.of(context).push<ItemModel>(
      MaterialPageRoute(
        builder: (ctx) => EditList(listId: widget.id, listName: widget.name, listColor: widget.color),
      ),
    );

    widget.refreshData();
  }

  void _isDone(ItemModel item, bool boolValue) async {
    final url = Uri.https(
      'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
      'lists/${widget.id}/items/${item.id}.json',
    );

    await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isDone': boolValue}),
    );

    setState(() {
      item.isDone = boolValue;
    });
  }

  void _removeItem(ItemModel item) {
    final url = Uri.https(
        'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
        'lists/${widget.id}/items/${item.id}.json');

    http.delete(url);

    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('Lista jest pusta'));

    if (_items.isNotEmpty) {
      content = ListView.builder(
        itemCount: _items.length,
        itemBuilder: (ctx, index) {
          if (!_items[index].isDone || !showItems) {
            return Dismissible(
              onDismissed: (direction) {
                _removeItem(_items[index]);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              key: ValueKey(_items[index].id),
              child: ListTile(
                title: Text(_items[index].name),
                leading: Text(
                  _items[index].quantity.toString(),
                ),
                trailing: Checkbox(
                  value: _items[index].isDone,
                  onChanged: (value) {
                    if (value == true) {
                      _isDone(_items[index], true);
                    }else {
                      _isDone(_items[index], false);
                    }
                  },
                ),
              ),
            );
          } else{
            return Container();
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: widget.color.colorCode,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showItems = !showItems;
              });
            },
            icon: showItems
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
          IconButton(
            onPressed: _editList,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}