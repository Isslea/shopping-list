import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lol/widgets/shopping_list.dart';

import '../data/colors.dart';
import '../models/colorModel.dart';
import '../models/shoppingListModel.dart';

class EditList extends StatefulWidget {
  final String listId;
  final String listName;
  final ColorModel listColor;

  const EditList({Key? key, required this.listId, required this.listName, required this.listColor}) : super(key: key);

  @override
  State<EditList> createState() {
    return _EditListState();
  }
}

class _EditListState extends State<EditList> {
  final _formKey = GlobalKey<FormState>();
  late String _enteredName;
  late ColorModel _selectedColor;

  @override
  void initState() {
    super.initState();
    _enteredName = widget.listName;
    _selectedColor = widget.listColor;
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
          'lists/${widget.listId}.json');
      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'color': _selectedColor.colorName,
          },
        ),
      );
      if(!context.mounted) {
        return;
      }
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowa lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Nazwa listy'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dodaj Liste';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
                initialValue: _enteredName,
              ),
              DropdownButtonFormField(
                value: _selectedColor,
                items: [
                  for (final color in colorsData.entries)
                    DropdownMenuItem(
                      value: color.value,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: color.value.colorCode,
                          ),
                          const SizedBox(width: 6),
                          Text(color.value.colorName),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedColor = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Dodaj'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
