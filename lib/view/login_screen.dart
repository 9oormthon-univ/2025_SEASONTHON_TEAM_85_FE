import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthViewModel authViewModel;
  final TextEditingController _accountIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isInputCompleted = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    authViewModel = context.read<AuthViewModel>();

    _accountIdController.addListener(_updateInputState);
    _passwordController.addListener(_updateInputState);
  }

  void _updateInputState() {
    setState(() {
      isInputCompleted =
          _accountIdController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _accountIdController.removeListener(() {
      setState(() {});
    });
    _passwordController.removeListener(() {
      setState(() {});
    });
    _accountIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> clickLoginButton() async {
    String accountId = _accountIdController.text;
    String password = _passwordController.text;

    if (!mounted) return; // State가 dispose 되었는지 먼저 확인

    try {
      int statusCode = await authViewModel.login(
        accountId: accountId,
        password: password,
        deviceId: "device-id-1234",
        provider: "ios",
      );

      if (!mounted) return; // async gap 이후에도 확인

      if (statusCode == 200) {
        if (context.mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          errorMessage = '로그인에 실패했습니다. 상태 코드: $statusCode';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = '로그인 중 오류가 발생했습니다: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea는 화면 상단의 노치나 하단 영역을 침범하지 않게 합니다.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // SingleChildScrollView를 사용해 키보드가 올라올 때 화면이 깨지는 것을 방지합니다.
          child: SingleChildScrollView(
            child: SizedBox(
              // 화면의 높이를 최소 높이로 설정하여 콘텐츠를 세로 중앙에 배치
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Spacer를 사용해 상단 공간을 유연하게 조절
                  const Spacer(flex: 2),

                  // 1. 로고 및 서브타이틀 섹션
                  _buildLogoSection(),
                  const SizedBox(height: 48),

                  // 2. 아이디 및 비밀번호 입력 필드 섹션
                  _buildInputField(hintText: '아이디'),
                  const SizedBox(height: 12),
                  _buildInputField(hintText: '비밀번호', isPassword: true),
                  const SizedBox(height: 24),

                  // 3. 회원가입 링크 섹션
                  _buildSignUpLink(),
                  const Spacer(flex: 3),

                  // 4. 로그인 버튼 섹션
                  _buildLoginButtons(context),
                  const SizedBox(height: 16), // 하단 여백
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. 로고 위젯
  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset('assets/images/main_logo.png', width: 400),
        const SizedBox(height: 8),
        const Text(
          '첫 여정을 Future Finder와 함께',
          style: TextStyle(fontSize: 15, color: Color(0xFF454549)),
        ),
      ],
    );
  }

  // 2. 입력 필드 위젯
  Widget _buildInputField({required String hintText, bool isPassword = false}) {
    return TextField(
      controller: isPassword ? _passwordController : _accountIdController,
      obscureText: isPassword, // 비밀번호 숨김 처리
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 184, 184, 184)),
        filled: true,
        fillColor: const Color.fromARGB(255, 236, 241, 248),
        // 테두리 없음
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  // 3. 회원가입 링크 위젯
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('계정이 없으신가요? ', style: TextStyle(color: Colors.black)),
        // GestureDetector를 사용해 텍스트에 탭 이벤트를 추가
        GestureDetector(
          onTap: () {
            // 회원가입 페이지로 이동하는 로직
            debugPrint("회원가입 tapped");
          },
          child: const Text(
            '회원가입',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // 4. 로그인 버튼 위젯
  Widget _buildLoginButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage.isNotEmpty) ...[
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        // 일반 로그인 버튼
        ElevatedButton(
          onPressed: isInputCompleted ? clickLoginButton : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
          ),
          child: const Text(
            '로그인 (메인화면 이동, 테스트용)',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        // 카카오 로그인 버튼
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE500), // 카카오 공식 노란색
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble, size: 20),
              SizedBox(width: 8),
              Text(
                '카카오로 로그인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
