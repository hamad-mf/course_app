import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_controller.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminController>(context, listen: false).loadDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Provider.of<AdminController>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => adminCtrl.loadDashboardStats(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;

          int gridCount = maxWidth > 1100
              ? 4
              : maxWidth > 700
              ? 3
              : maxWidth > 500
              ? 2
              : 1;

          return Center(
            child: Container(
              width: maxWidth > 1200 ? 1200 : maxWidth,
              padding: const EdgeInsets.all(16.0),
              child: adminCtrl.loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---------------- SUMMARY CARDS ----------------
                          GridView.count(
                            crossAxisCount: gridCount,
                            shrinkWrap: true,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 2.2,
                            children: [
                              _summaryCard(
                                'Users',
                                '${adminCtrl.totalUsers}',
                                Icons.people,
                              ),
                              _summaryCard(
                                'Courses',
                                '${adminCtrl.totalCourses}',
                                Icons.book,
                              ),
                              _summaryCard(
                                'Revenue',
                                '₹ ${adminCtrl.totalSales.toStringAsFixed(2)}',
                                Icons.currency_rupee,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ---------------- ADMIN ACTIONS PANEL ----------------
                          const Text(
                            "Admin Actions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                bool wide = constraints.maxWidth > 600;

                                return wide
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: _dashboardButton(
                                              icon: Icons.add,
                                              label: "Add New Course",
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                '/add_course',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _dashboardButton(
                                              icon: Icons.menu_book,
                                              label: "Manage Courses",
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                '/admin_courses',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _dashboardButton(
                                            icon: Icons.add,
                                            label: "Add New Course",
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              '/add_course',
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          _dashboardButton(
                                            icon: Icons.menu_book,
                                            label: "Manage Courses",
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              '/admin_courses',
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ),

                          const SizedBox(height: 25),

                          // ---------------- REVENUE SECTION ----------------
                          _sectionContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Revenue (latest orders)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Total from fetched orders: ₹ ${adminCtrl.totalSales.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Orders fetched: ${adminCtrl.recentOrders.length}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ---------------- RECENT ORDERS ----------------
                          const Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          adminCtrl.recentOrders.isEmpty
                              ? _sectionContainer(
                                  height: 70,
                                  child: const Center(
                                    child: Text(
                                      'No recent orders',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                )
                              : _recentOrdersList(adminCtrl.recentOrders),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  // -------------------- UI COMPONENTS --------------------

  Widget _summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF7B61A1),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionContainer({required Widget child, double height = 0}) {
    return Container(
      height: height == 0 ? null : height,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B61A1),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _recentOrdersList(List<OrderModel> orders) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final o = orders[i];
        return _sectionContainer(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order: ${o.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Course: ${o.courseId}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "User: ${o.userId}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹ ${o.amount.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(o.status, style: const TextStyle(color: Colors.white70)),
                  if (o.createdAt != null)
                    Text(
                      "${o.createdAt}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
