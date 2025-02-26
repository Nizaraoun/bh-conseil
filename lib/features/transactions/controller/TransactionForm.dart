import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, double, String) onSubmit;

  TransactionForm({required this.onSubmit});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: 'Titre'),
        ),
        TextField(
          controller: _amountController,
          decoration: InputDecoration(labelText: 'Montant'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _dateController,
          decoration: InputDecoration(labelText: 'Date'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final amount = double.parse(_amountController.text);
            final date = _dateController.text;
            widget.onSubmit(title, amount, date);
            Get.back();
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}
