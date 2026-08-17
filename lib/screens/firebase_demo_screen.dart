import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_service.dart';

class FirebaseDemoScreen extends StatelessWidget {
  const FirebaseDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = context.watch<FirebaseService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Sync')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebaseService.streamCollection('reports'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index].data();
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(doc['text']?.toString() ?? 'No text'),
                  subtitle: Text('Stored in Firestore'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
