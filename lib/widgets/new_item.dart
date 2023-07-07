import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lol/models/itemModel.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  final String listId;
  final Color listColorCode;

  const NewItem({Key? key, required this.listId, required this.listColorCode}) : super(key: key);

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-list-634c1-default-rtdb.europe-west1.firebasedatabase.app',
          'lists/${widget.listId}/items.json');
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'isDone': false
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
        title: const Text('Nowy produkt'),
        backgroundColor: widget.listColorCode,
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
                  label: Text('Produkt'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Dodaj produkt';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Ilość'),
                ),
                keyboardType: TextInputType.number,
                initialValue: _enteredQuantity.toString(),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.tryParse(value)! <= 0) {
                    return 'Liczba musi byc dodatnia';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredQuantity = int.parse(value!);
                },
              ),
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