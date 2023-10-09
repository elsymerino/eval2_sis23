import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crud Firebase',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DSW23'),
    );
  }
}

class MyForm extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  void _guardarDatos(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('tb-productos').add({
        'idProducto': idController.text,
        'nombre': nombreController.text,
        'precio': precioController.text,
        'stock': stockController.text,
      });

      // Resetear los controladores después de guardar
      idController.clear();
      nombreController.clear();
      precioController.clear();
      stockController.clear();

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Los datos se han guardado exitosamente'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons
                      .credit_card), // Cambiado a una tarjeta de identificación
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: idController,
                      decoration: InputDecoration(labelText: 'ID'),
                      validator: _validateField,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.shopping_basket), // Cambiado a un producto
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      validator: _validateField,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.money), // Cambiado a un billete
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: precioController,
                      decoration: InputDecoration(labelText: 'Precio'),
                      validator: _validateField,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.shopping_cart), // Cambiado a una caja
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: stockController,
                      decoration: InputDecoration(labelText: 'Stock'),
                      validator: _validateField,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: 60,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _guardarDatos(context),
                  child: Icon(Icons.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MyForm(),
              SizedBox(height: 20),
              ListaRegistros(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaRegistros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tb-productos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var registros = snapshot.data!.docs;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Stock')),
              ],
              rows: registros.map((registro) {
                var data = registro.data() as Map<String, dynamic>;
                return DataRow(
                  cells: [
                    DataCell(Text(data['idProducto'])),
                    DataCell(Text(data['nombre'])),
                    DataCell(Text(data['precio'])),
                    DataCell(Text(data['stock'])),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
