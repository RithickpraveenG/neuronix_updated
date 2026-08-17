// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import 'package:provider/provider.dart';

import 'package:neuronix/main.dart';
import 'package:neuronix/screens/report_upload_screen.dart';
import 'package:neuronix/services/auth_service.dart';
import 'package:neuronix/services/firebase_service.dart';
import 'package:neuronix/services/network_service.dart';

class _FakeImagePickerPlatform extends ImagePickerPlatform {
  static bool wasCalled = false;

  @override
  Future<PickedFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    wasCalled = true;
    final file = File('${Directory.systemTemp.path}/patient_lab_report.png');
    await file.writeAsBytes([1, 2, 3, 4]);
    return PickedFile(file.path);
  }
}

void main() {
  setUp(() {
    ImagePickerPlatform.instance = _FakeImagePickerPlatform();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => FirebaseService()),
          ChangeNotifierProvider(create: (_) => NetworkService()),
        ],
        child: const NeuronixApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('report upload screen supports selecting a file', (WidgetTester tester) async {
    _FakeImagePickerPlatform.wasCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthService()),
            ChangeNotifierProvider(create: (_) => FirebaseService()),
            ChangeNotifierProvider(create: (_) => NetworkService()),
          ],
          child: const ReportUploadScreen(),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Choose File'));
    await tester.pumpAndSettle();

    expect(_FakeImagePickerPlatform.wasCalled, isTrue);
  });
}
