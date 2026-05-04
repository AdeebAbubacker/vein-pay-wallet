import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vein_pay_wallet/core/network/api_client.dart';
import 'package:vein_pay_wallet/core/session/session_manager.dart';
import 'package:vein_pay_wallet/core/storage/secure_storage_service.dart';
import 'package:vein_pay_wallet/data/repositories/auth_repository.dart';
import 'package:vein_pay_wallet/data/repositories/wallet_repository.dart';
import 'package:vein_pay_wallet/data/services/auth_api_service.dart';
import 'package:vein_pay_wallet/data/services/wallet_api_service.dart';
import 'package:vein_pay_wallet/viewmodels/login_viewmodel.dart';
import 'package:vein_pay_wallet/viewmodels/transaction_viewmodel.dart';
import 'package:vein_pay_wallet/viewmodels/wallet_viewmodel.dart';
import 'package:vein_pay_wallet/views/auth/login_screen.dart';
import 'package:vein_pay_wallet/views/layout/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VeinPayApp());
}

class VeinPayApp extends StatefulWidget {
  const VeinPayApp({super.key});

  @override
  State<VeinPayApp> createState() => _VeinPayAppState();
}

class _VeinPayAppState extends State<VeinPayApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final SessionManager _sessionManager;
  late final SecureStorageService _secureStorageService;
  late final http.Client _httpClient;
  late final ApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final WalletRepository _walletRepository;

  SessionStatus _lastHandledSessionStatus = SessionStatus.unknown;

  @override
  void initState() {
    super.initState();
    _sessionManager = SessionManager();
    _secureStorageService = SecureStorageService();
    _httpClient = http.Client();
    _apiClient = ApiClient(
      httpClient: _httpClient,
      secureStorageService: _secureStorageService,
      onSessionExpired: () async {
        await _authRepository.handleSessionExpired();
      },
    );

    final authApiService = AuthApiService(_apiClient);
    final walletApiService = WalletApiService(_apiClient);

    _authRepository = AuthRepository(
      authApiService: authApiService,
      secureStorageService: _secureStorageService,
      sessionManager: _sessionManager,
    );
    _walletRepository = WalletRepository(walletApiService);

    _sessionManager.addListener(_handleSessionChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authRepository.restoreSession();
    });
  }

  @override
  void dispose() {
    _sessionManager.removeListener(_handleSessionChange);
    _sessionManager.dispose();
    _httpClient.close();
    super.dispose();
  }

  void _handleSessionChange() {
    final sessionStatus = _sessionManager.value;
    if (sessionStatus == SessionStatus.unknown ||
        sessionStatus == _lastHandledSessionStatus) {
      return;
    }

    _lastHandledSessionStatus = sessionStatus;
    final navigator = _navigatorKey.currentState;
    if (navigator == null) {
      return;
    }

    final Widget destination = sessionStatus == SessionStatus.authenticated
        ? const _MainFlowScreen()
        : const _LoginFlowScreen();

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepository),
        RepositoryProvider<WalletRepository>.value(value: _walletRepository),
      ],
      child: MaterialApp(
        title: 'Vein-PAY',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.montserratTextTheme(
            ThemeData.dark().textTheme,
          ),
          primaryColor: const Color(0xFF6A1B9A),
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF8E44AD),
            secondary: Color(0xFF03DAC6),
            surface: Color(0xFF1E1E1E),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1E1E1E),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8E44AD),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
            ),
          ),

          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF1E1E1E),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1E1E1E),
            selectedItemColor: Color(0xFF03DAC6),
            unselectedItemColor: Colors.grey,
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const _BootScreen(),
      ),
    );
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _LoginFlowScreen extends StatelessWidget {
  const _LoginFlowScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(context.read<AuthRepository>()),
      child: const LoginScreen(),
    );
  }
}

class _MainFlowScreen extends StatelessWidget {
  const _MainFlowScreen();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WalletViewModel(context.read<WalletRepository>()),
        ),
        BlocProvider(
          create: (_) => TransactionViewModel(context.read<WalletRepository>()),
        ),
      ],
      child: const MainScreen(),
    );
  }
}
