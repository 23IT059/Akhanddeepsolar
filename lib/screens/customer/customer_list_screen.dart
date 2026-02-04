import 'package:flutter/material.dart';
import '../../models/customer_model.dart';
import '../../services/database_helper.dart';
import 'add_edit_customer_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  late Future<List<Customer>> customers;

  @override
  void initState() {
    super.initState();
    _refreshCustomers();
  }

  void _refreshCustomers() {
    setState(() {
      customers = DatabaseHelper.instance.readAllCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Database')),
      body: FutureBuilder<List<Customer>>(
        future: customers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return const Center(child: Text('No customers found.'));
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final customer = snapshot.data![index];
              return ListTile(
                title: Text(customer.name),
                subtitle: Text(customer.propertyType),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        if (await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditCustomerScreen(customer: customer))) == true) {
                          _refreshCustomers();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.instance.delete(customer.id!);
                        _refreshCustomers();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          if (await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCustomerScreen())) == true) {
            _refreshCustomers();
          }
        },
      ),
    );
  }
}
