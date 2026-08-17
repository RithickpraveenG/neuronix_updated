import 'package:go_router/go_router.dart';

import '../screens/appointments_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/doctor_dashboard_screen.dart';
import '../screens/doctor_patient_detail_screen.dart';
import '../screens/firebase_demo_screen.dart';
import '../screens/health_dashboard_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/patient_home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/report_analysis_screen.dart';
import '../screens/report_upload_screen.dart';
import '../screens/symptom_checker_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/patient', builder: (context, state) => const PatientHomeScreen()),
      GoRoute(path: '/doctor', builder: (context, state) => const DoctorDashboardScreen()),
      GoRoute(path: '/report-upload', builder: (context, state) => const ReportUploadScreen()),
      GoRoute(
        path: '/report-analysis',
        builder: (context, state) {
          final reportText = state.extra as String? ?? 'No report text provided';
          return ReportAnalysisScreen(reportText: reportText);
        },
      ),
      GoRoute(path: '/symptom-checker', builder: (context, state) => const SymptomCheckerScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/health-dashboard', builder: (context, state) => const HealthDashboardScreen()),
      GoRoute(path: '/appointments', builder: (context, state) => const AppointmentsScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(
        path: '/doctor-patient-detail',
        builder: (context, state) {
          final patientName = state.extra as String? ?? 'Patient';
          return DoctorPatientDetailScreen(patientName: patientName);
        },
      ),
      GoRoute(path: '/firebase-demo', builder: (context, state) => const FirebaseDemoScreen()),
    ],
  );
}
