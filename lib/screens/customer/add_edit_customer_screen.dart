import 'package:flutter/material.dart';
import '../../models/customer_model.dart';
import '../../services/database_helper.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;
  const AddEditCustomerScreen({super.key, this.customer});

  @override
  _AddEditCustomerScreenState createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String phone;
  late String address;
  String propertyType = 'Residential';

  @override
  void initState() {
    super.initState();
    name = widget.customer?.name ?? '';
    phone = widget.customer?.phone ?? '';
    address = widget.customer?.address ?? '';
    propertyType = widget.customer?.propertyType ?? 'Residential';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Customer Name', border: OutlineInputBorder()),
                validator: (v) => v != null && v.isEmpty ? 'Enter Name' : null,
                onSaved: (v) => name = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => v != null && v.length < 10 ? 'Enter valid phone' : null,
                onSaved: (v) => phone = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (v) => v != null && v.isEmpty ? 'Enter Address' : null,
                onSaved: (v) => address = v!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: propertyType,
                decoration: const InputDecoration(labelText: 'Property Type', border: OutlineInputBorder()),
                items: ['Residential', 'Commercial'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => propertyType = v!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(widget.customer == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final customer = Customer(
        id: widget.customer?.id,
        name: name,
        phone: phone,
        address: address,
        propertyType: propertyType,
      );
      if (widget.customer == null) {
        await DatabaseHelper.instance.create(customer);
      } else {
        await DatabaseHelper.instance.update(customer);
      }
      if (mounted) Navigator.pop(context, true);
    }
  }
}
