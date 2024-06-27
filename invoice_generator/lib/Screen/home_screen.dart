import 'package:flutter/material.dart';
import 'package:invoice_generator/Screen/history_screen.dart';
import 'package:invoice_generator/Screen/invoice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IndexedStack(
        index: index,
        children: [
          InvoiceListPage(),
          const Invoice(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (newIndex) {
            setState(() {
              index = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: 'Invoice Generator')
          ]),
    );
  }
}
