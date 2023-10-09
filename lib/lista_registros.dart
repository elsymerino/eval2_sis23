import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        return ListView.builder(
          itemCount: registros.length,
          itemBuilder: (context, index) {
            var registro = registros[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text('ID Producto: ${registro['idProducto']}'),
              subtitle: Text(
                  'Nombre: ${registro['nombre']}, Precio: ${registro['precio']}, Stock: ${registro['stock']}'),
            );
          },
        );
      },
    );
  }
}
