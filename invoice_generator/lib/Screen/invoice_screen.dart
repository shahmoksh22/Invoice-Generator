import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../modal/images.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  List<Images> images = [
    Images(image: 'assets/images/image1.png'),
    Images(image: 'assets/images/image2.png'),
    Images(image: 'assets/images/image3.png'),
    Images(image: 'assets/images/image4.png'),
    Images(image: 'assets/images/image5.png'),
    Images(image: 'assets/images/image6.png'),
  ];

  final List<TextEditingController> _itemNameControllers = [];
  final List<TextEditingController> _itemPriceControllers = [];
  final List<TextEditingController> _itemQuantityControllers = [];
  int selectedIconIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final subtotal = _calculateSubtotal();
    // final gst = _calculateGST(subtotal);
    // final deliveryCharges = _calculateDeliveryCharges(subtotal);
    // final total = _calculateTotal(subtotal, gst, deliveryCharges);
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: IconButton(onPressed: (){
            setState(() {
              selectedIconIndex = -1;
              _itemNameControllers.clear();
              _itemPriceControllers.clear();
              _itemQuantityControllers.clear();
            });
            },icon:const  Icon(Icons.restore_rounded)),
        ),
        title: const Text('Invoice Generator'),
        titleTextStyle: GoogleFonts.abel(
            textStyle: const TextStyle(fontSize: 25, color: Colors.black)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.3),
            child: Text(
              'Logo Select',
              style: GoogleFonts.abel(
                  textStyle:
                      const TextStyle(fontSize: 25, color: Colors.black)),
            ),
          ),
          SizedBox(
            height: 140,
            child: Card(
              color: Colors.grey.shade400,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIconIndex = index;
                        });
                      },
                      child: Stack(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(20),
                            child: Image.asset(images[index].image),
                          ),
                          if (selectedIconIndex == index)
                            const Padding(
                              padding: EdgeInsets.only(top: 100.0, left: 100),
                              child: Icon(
                                Icons.verified,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.3),
            child: Text(
              'Add Item',
              style: GoogleFonts.abel(
                  textStyle:
                      const TextStyle(fontSize: 25, color: Colors.black)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _itemNameControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 300,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            // Item name text field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _itemNameControllers[index],
                                decoration: const InputDecoration(
                                    label: Text('Item Name'),
                                    border: OutlineInputBorder()),
                              ),
                            ),

                            // Item price text field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _itemPriceControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label: Text('Item Price'),
                                    border: OutlineInputBorder()),
                              ),
                            ),

                            // Item quantity text field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _itemQuantityControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    label: Text('Quantity'),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _itemNameControllers.add(TextEditingController());
                      _itemPriceControllers.add(TextEditingController());
                      _itemQuantityControllers.add(TextEditingController());
                    });
                  },
                  child: const Text('Add Item'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: selectedIconIndex < 0 ? null : () => sharePDF(),
                    child: const Text('Share PDF'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> sharePDF() async {
    final pdf = pw.Document();
    final subtotal = _calculateSubtotal();
    final gst = _calculateGST(subtotal);
    final deliveryCharges = _calculateDeliveryCharges(subtotal);
    final total = _calculateTotal(subtotal, gst, deliveryCharges);
    final image = await imageFromAssetBundle(images[selectedIconIndex].image);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('INVOICE GENERATOR',
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.bold)),
                      pw.Divider(),
                      pw.Image(image, height: 52),
                    ]),
                pw.Row(children: [
                  pw.Text('BILLED TO:',
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  pw.Spacer(),
                  pw.Text('Kevin H Panchal',
                      style: const pw.TextStyle(fontSize: 15)),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text('Pay TO:',
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  pw.Spacer(),
                  pw.Text('Ahmedabad',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text('Bank:', style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('HDFC bank',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text('Account Name:',
                      style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('Random Name',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text('IFSC:', style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('HDFC001515151',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 5),
                pw.Row(children: [
                  pw.Text('Account Number:',
                      style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('154225 1510200',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 15),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(0),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text('Product Name'),
                                pw.SizedBox(width: 180),
                                pw.Text('Price'),
                                pw.SizedBox(width: 155),
                                pw.Text('Quantity'),
                              ]),
                        ],
                      ),
                      pw.SizedBox(width: 10),
                    ],
                  ),
                ),
                pw.Divider(),
                pw.ListView.builder(
                    itemBuilder: (context, index) {
                      return pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 0),
                          child: pw.Column(children: [
                            pw.Row(children: [
                              pw.Text(_itemNameControllers[index].text),
                              pw.Spacer(),
                              // pw.SizedBox(width: 150),
                              pw.Text(_itemPriceControllers[index].text),
                              pw.Spacer(),
                              pw.Text(_itemQuantityControllers[index].text),
                            ]),
                            pw.Divider(),
                          ]));
                    },
                    itemCount: _itemNameControllers.length),
                pw.Row(children: [
                  pw.Text('SubTotal', style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('\$$subtotal',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.Row(children: [
                  pw.Text('Delivery(Get free Delivery on bill above \$500)',
                      style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('\$$deliveryCharges',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.Row(children: [
                  pw.Text('GST Total(15%)',
                      style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('\$${gst}',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.Divider(),
                pw.Row(children: [
                  pw.Text('Total', style: const pw.TextStyle(fontSize: 15)),
                  pw.Spacer(),
                  pw.Text('\$$total',
                      style: const pw.TextStyle(
                        fontSize: 15,
                      )),
                ]),
                pw.SizedBox(height: 50),
                pw.Text(
                    'Payment is required within 14 business days of invoice date. Please send remittance to hello@rellygreatsite.com.'),
                pw.SizedBox(height: 50),
                pw.Text('Thank you for your business'),
              ],
            ),
          ); // Center
        },
      ),
    ); //

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile('${output.path}/$fileName.pdf')], text: 'Invoice Generator');
  }

  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (int i = 0; i < _itemNameControllers.length; i++) {
      final priceText = _itemPriceControllers[i].text;
      final quantityText = _itemQuantityControllers[i].text;
      if (priceText.isNotEmpty && quantityText.isNotEmpty) {
        final price = double.tryParse(priceText);
        final quantity = double.tryParse(quantityText);
        if (price != null && quantity != null) {
          subtotal += price * quantity;
        }
      }
    }
    return subtotal;
  }

  double _calculateGST(double subtotal) {
    return subtotal * 0.15;
  }

  double _calculateDeliveryCharges(double subtotal) {
    if (subtotal >= 1 && subtotal < 100) {
      return 2.0;
    } else if (subtotal >= 100 && subtotal <= 200) {
      return 5.0;
    } else if (subtotal > 200 && subtotal <= 250) {
      return 8.0;
    } else if (subtotal > 250 && subtotal <= 500) {
      return 10.0;
    } else {
      return 0.0;
    }
  }

  double _calculateTotal(double subtotal, double gst, double deliveryCharges) {
    return subtotal + gst + deliveryCharges;
  }
}
