import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lol/models/shoppingListModel.dart';
import 'package:lol/widgets/new_list.dart';

import '../data/colors.dart';
import 'item_list.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<ShoppingListModel> _shoppingItems = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  void _loadLists() async {
    final url = Uri.https(
        'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
        'lists.json');
    final response = await http.get(url);
    final Map<String, dynamic>? listData = json.decode(response.body);
    final List<ShoppingListModel> _loadedItems = [];
    if (listData != null) {
      for (final item in listData.entries) {
        final findColor = colorsData.entries
            .firstWhere((x) => x.value.colorName == item.value['color'])
            .value;

        _loadedItems.add(
          ShoppingListModel(
            id: item.key,
            name: item.value['name'],
            color: findColor,
          ),
        );
      }
    }
    setState(() {
      _shoppingItems = _loadedItems;
    });
  }

  void _addList() async {
     await Navigator.of(context).push<ShoppingListModel>(
      MaterialPageRoute(
        builder: (ctx) => const NewList(),
      ),
    );

  _loadLists();

  }

  void _removeItem(ShoppingListModel item) {
    final url = Uri.https(
        'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
        'lists/${item.id}.json');

    http.delete(url);

    setState(() {
      _shoppingItems.remove(item);
    });

  }

  void _viewGroceryList(ShoppingListModel list) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ItemList(
            id: list.id,
            name: list.name,
            color: list.color,
            refreshData: _refreshData,
        ),
      ),
    );
  }

  void _refreshData() {
    // Fetch the data again
    _loadLists();
  }


  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('Lista jest pusta'));

    if (_shoppingItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _shoppingItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
              _removeItem(_shoppingItems[index]);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          key: ValueKey(_shoppingItems[index].id),
          child: ListTile(
            title: Text(_shoppingItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _shoppingItems[index].color.colorCode,
            ),
            onTap: () {
              _viewGroceryList(_shoppingItems[index]);
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listy'),
        actions: [
          IconButton(
            onPressed: _addList,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}