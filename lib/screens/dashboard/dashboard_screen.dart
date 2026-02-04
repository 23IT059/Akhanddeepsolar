import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/database_helper.dart';
import '../../models/customer_model.dart';
import '../customer/customer_list_screen.dart';
import '../customer/add_edit_customer_screen.dart';

// Mock Models for Quotation
class Quotation {
  final String customerName;
  final double systemSizeKw;
  final double netCost;
  final String status;
  Quotation(this.customerName, this.systemSizeKw, this.netCost, this.status);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock Data for Quotations only
  final List<Quotation> _recentQuotations = [
    Quotation('Rahul Sharma', 5.0, 250000, 'sent'),
  ];

  void _showCustomerSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New'),
                  ),
                ],
              ),
            ),
             Expanded(
              child: FutureBuilder<List<Customer>>(
                future: DatabaseHelper.instance.readAllCustomers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No customers found.'));
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final customer = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(child: Text(customer.name[0])),
                        title: Text(customer.name),
                        subtitle: Text(customer.phone),
                        onTap: () => Navigator.pop(ctx),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             UserAccountsDrawerHeader(
              accountName: const Text('Akhanddeep User'),
              accountEmail: const Text('user@akhanddeep.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              decoration: const BoxDecoration(color: AppColors.primary),
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text('Customers'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                 await AuthService().signOut();
                 if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCustomerSelectionDialog(context),
        label: const Text('New Quotation'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerListScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                      child: FutureBuilder<List<Customer>>(
                        future: DatabaseHelper.instance.readAllCustomers(),
                        builder: (ctx, snap) => Column(
                          children: [
                            const Icon(Icons.people, size: 30, color: Colors.blue),
                            const SizedBox(height: 8),
                            Text(snap.hasData ? '${snap.data!.length}' : '-', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('Customers'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

