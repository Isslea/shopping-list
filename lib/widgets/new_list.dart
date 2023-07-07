import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lol/widgets/shopping_list.dart';

import '../data/colors.dart';
import '../models/colorModel.dart';
import '../models/shoppingListModel.dart';

class NewList extends StatefulWidget {
  const NewList({super.key});

  @override
  State<NewList> createState() {
    return _NewListState();
  }
}

class _NewListState extends State<NewList> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _selectedColor = colorsData[ColorType.green]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
          'lists.json');
      await http.post(
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
      Navigator.of(context).pop();
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
