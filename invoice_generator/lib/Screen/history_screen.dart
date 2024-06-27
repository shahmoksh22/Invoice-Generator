import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

Future<List<File>> getInvoices() async {
  List<File> invoices = [];
  Directory? directory = await getApplicationDocumentsDirectory(); // or any directory where your PDFs are stored
  List<FileSystemEntity> files = directory.listSync(recursive: false);
  for (FileSystemEntity file in files) {
    if (file is File && file.path.endsWith('.pdf')) {
      invoices.add(file);
    }
  }
  return invoices;
}


class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  List<File> invoices = [];

  @override
  void initState() {
    super.initState();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    List<File> loadedInvoices = await getInvoices();
    setState(() {
      invoices = loadedInvoices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: IconButton(onPressed: loadInvoices,icon:const  Icon(Icons.history_rounded))
        ),
        title: const Text('Invoice History'),
        titleTextStyle: GoogleFonts.abel(
            textStyle: const TextStyle(fontSize: 25, color: Colors.black)),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(invoices[index].path.split('/').last),
            ),
          );
        },
      ),
    );
  }
}