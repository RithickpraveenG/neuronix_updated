import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/neuronix_button.dart';
import '../widgets/neuronix_card.dart';
import '../widgets/responsive_scaffold.dart';

class ReportUploadScreen extends StatefulWidget {
  const ReportUploadScreen({super.key});

  @override
  State<ReportUploadScreen> createState() => _ReportUploadScreenState();
}

class _ReportUploadScreenState extends State<ReportUploadScreen> {
  final TextEditingController _textController = TextEditingController(
    text:
        'Patient presents with blood pressure 140/90 mmHg, elevated WBC count of 12,500 cells/mcL, mild fever 101.2 F, dry cough, and acute fatigue over 3 days.',
  );
  final ImagePicker _picker = ImagePicker();

  String? _selectedFileName;
  int? _selectedFileSize;
  bool _isProcessing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _simulateFileSelect(String filename, int sizeBytes) {
    setState(() {
      _selectedFileName = filename;
      _selectedFileSize = sizeBytes;
    });
  }

  Future<void> _pickReportFile() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }

      final sizeBytes = await pickedFile.length();
      final fileName = pickedFile.name.split('/').last.split('\\').last;
      setState(() {
        _selectedFileName = fileName;
        _selectedFileSize = sizeBytes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick a report: $e')),
      );
    }
  }

  Future<void> _analyzeReport() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a document or paste report text.')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    context.push('/report-analysis', extra: text);
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: 'Medical Report Upload',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Medical Document',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Extract text via Tesseract OCR and run spaCy NLP entity recognition.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // Upload Card / Dropzone (responsive)
                NeuronixCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E88E5).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload_outlined, size: 44, color: Color(0xFF1E88E5)),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Upload Medical Report File',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Supports PDF, PNG, JPG files up to 15MB',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 420;
                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _pickReportFile,
                                icon: const Icon(Icons.attach_file, color: Color(0xFF1E88E5)),
                                label: const Text('Choose File'),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () => _simulateFileSelect('blood_panel_lab_results.pdf', 1024 * 450),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                label: const Text('Sample PDF'),
                              ),
                              const SizedBox(height: 8),
                              OutlinedButton.icon(
                                onPressed: () => _simulateFileSelect('chest_xray_report.png', 1024 * 820),
                                icon: const Icon(Icons.image, color: Colors.blue),
                                label: const Text('Sample Image'),
                              ),
                            ],
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _pickReportFile,
                                icon: const Icon(Icons.attach_file, color: Color(0xFF1E88E5)),
                                label: const Text('Choose File'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _simulateFileSelect('blood_panel_lab_results.pdf', 1024 * 450),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                label: const Text('Sample PDF'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _simulateFileSelect('chest_xray_report.png', 1024 * 820),
                                icon: const Icon(Icons.image, color: Colors.blue),
                                label: const Text('Sample Image'),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                if (_selectedFileName != null) ...[
                  const SizedBox(height: 16),
                  NeuronixCard(
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, color: Color(0xFF1E88E5), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedFileName!, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${(_selectedFileSize! / 1024).toStringAsFixed(1)} KB • Ready for OCR extraction'),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => setState(() {
                            _selectedFileName = null;
                            _selectedFileSize = null;
                          }),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                const Text(
                  'Or Paste Report Text directly:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _textController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Medical Report Text Content',
                    hintText: 'Paste clinical notes, discharge summaries, or laboratory values...',
                  ),
                ),
                const SizedBox(height: 20),

                NeuronixButton(
                  label: 'Analyze Report with AI',
                  icon: Icons.auto_awesome,
                  isLoading: _isProcessing,
                  onPressed: _analyzeReport,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
