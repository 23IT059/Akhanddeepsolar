import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../services/auth_service.dart';

// Mock Models
class Customer {
  final String name;
  final String propertyType;
  final String phone;
  Customer(this.name, this.propertyType, this.phone);
}

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
  // Mock Data
  final List<Customer> _customers = [
    Customer('Rahul Sharma', 'Residential', '9876543210'),
    Customer('Priya Patel', 'Commercial', '9876543211'),
  ];
  
  final List<Quotation> _recentQuotations = [
    Quotation('Rahul Sharma', 5.0, 250000, 'sent'),
    Quotation('Priya Patel', 10.5, 480000, 'accepted'),
    Quotation('Amit Singh', 3.0, 150000, 'rejected'),
  ];

  void _showCustomerSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Customer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      // Navigator.pushNamed(context, '/add-customer'); 
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _customers.length,
                itemBuilder: (_, index) {
                  final customer = _customers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          customer.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(customer.name),
                      subtitle: Text('${customer.propertyType} • ${customer.phone}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pop(ctx);
                        // Navigator.pushNamed(context, '/quotation-flow', arguments: customer);
                      },
                    ),
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
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
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
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outlined),
              title: const Text('Customers'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_quote_outlined),
              title: const Text('Quotations'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                 await AuthService().signOut();
                 if (context.mounted) {
                   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                 }
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
            _buildStatCards(context),
            const SizedBox(height: 24),
            const Text(
              'Recent Quotations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentQuotations(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {}, // Navigate to customers
            child: _buildStatCard(
              'Customers',
              '${_customers.length}',
              Icons.people_outlined,
              Colors.blue,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {}, // Navigate to quotations
            child: _buildStatCard(
              'Quotations',
              '${_recentQuotations.length}',
              Icons.description_outlined,
              Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentQuotations() {
    if (_recentQuotations.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.description_outlined, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 12),
                Text(
                  'No quotations yet',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentQuotations.length,
      itemBuilder: (context, index) {
        final quotation = _recentQuotations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.description_outlined, color: AppColors.primary),
            ),
            title: Text(
              quotation.customerName.isNotEmpty 
                  ? quotation.customerName 
                  : 'Customer',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${quotation.systemSizeKw.toStringAsFixed(1)} kW • ${_formatCurrency(quotation.netCost)}',
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(quotation.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quotation.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(quotation.status),
                ),
              ),
            ),
            onTap: () {
              // Navigator.pushNamed(context, '/quotations');
            },
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(amount);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'sent':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }
}
