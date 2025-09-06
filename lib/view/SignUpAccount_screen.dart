import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class SignUpAccountScreen extends StatefulWidget {
  const SignUpAccountScreen({super.key});

  @override
  State<SignUpAccountScreen> createState() => _SignUpAccountScreenState();
}

class _SignUpAccountScreenState extends State<SignUpAccountScreen> {
  // controllers
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pw2Controller = TextEditingController();
  final _emailLocalController = TextEditingController();
  final _emailDomainCustomController = TextEditingController();

  // states
  bool _idChecked = false;
  bool _isPwObscure = true;
  bool _isPw2Obscure = true;
  String _selectedDomain = '선택';
  String _error = '';

  static const _fillColor = Color(0xFFECF1F8);
  static const _hintColor = Color(0xFFB8B8B8);
  static const _blue = Color(0xFF1737C4);

  final _domains = const <String>[
    '선택',
    'gmail.com',
    'naver.com',
    'daum.net',
    'hanmail.net',
    'nate.com',
    '직접입력',
  ];

  @override
  void initState() {
    super.initState();
    // 아이디가 변경되면 다시 중복확인 필요
    _idController.addListener(() {
      if (_idChecked) setState(() => _idChecked = false);
      setState(() {}); // 버튼 활성화 재평가
    });
    _pwController.addListener(() => setState(() {}));
    _pw2Controller.addListener(() => setState(() {}));
    _emailLocalController.addListener(() => setState(() {}));
    _emailDomainCustomController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pw2Controller.dispose();
    _emailLocalController.dispose();
    _emailDomainCustomController.dispose();
    super.dispose();
  }

  // ---------- validators ----------
  bool get _validId =>
      RegExp(r'^[a-zA-Z0-9]{4,12}$').hasMatch(_idController.text.trim());

  bool get _validPw {
    final s = _pwController.text;
    if (s.length < 6 || s.length > 12) return false;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(s);
    final hasDigit = RegExp(r'\d').hasMatch(s);
    final hasSpecial = RegExp(r'[^\w\s]').hasMatch(s);
    final kinds = [hasLetter, hasDigit, hasSpecial].where((e) => e).length;
    return kinds >= 2;
  }

  bool get _pwMatched =>
      _pwController.text.isNotEmpty && _pwController.text == _pw2Controller.text;

  bool get _validEmailLocal =>
      RegExp(r"^[A-Za-z0-9._%+\-]+$").hasMatch(_emailLocalController.text) &&
          _emailLocalController.text.isNotEmpty;

  bool get _usingCustomDomain => _selectedDomain == '직접입력';

  bool get _validEmailDomain {
    if (_selectedDomain == '선택') return false;
    if (!_usingCustomDomain) return true;
    final d = _emailDomainCustomController.text.trim();
    // 매우 간단한 도메인 검증
    return RegExp(r"^[A-Za-z0-9\-]+\.[A-Za-z]{2,}$").hasMatch(d);
  }

  bool get _formValid =>
      _idChecked &&
          _validId &&
          _validPw &&
          _pwMatched &&
          _validEmailLocal &&
          _validEmailDomain;

  String get _fullEmail {
    final d = _usingCustomDomain
        ? _emailDomainCustomController.text.trim()
        : _selectedDomain;
    return "${_emailLocalController.text.trim()}@$d";
  }

  // ---------- actions ----------
  Future<void> _checkIdDuplicated() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = '');

    debugPrint('[CheckID] validId=$_validId, id="${_idController.text.trim()}"');

    if (!_validId) {
      setState(() => _error = '아이디 형식을 확인해주세요. (영문/숫자 4~12자)');
      return;
    }

    try {
      final vm = Provider.of<AuthViewModel>(context, listen: false);

      debugPrint('[CheckID] draft -> nick=${vm.signupNickname}, '
          'name=${vm.signupName}, birth=${vm.signupBirth6}-${vm.signupBirth1}, '
          'phone=${vm.signupPhone}');

      final status = await vm.signUpWithSavedBasics(
        accountId: _idController.text.trim(),
      );

      debugPrint('[CheckID] signUpWithSavedBasics.status=$status');

      if (!mounted) return;

      if (status == 200 || status == 201) {
        setState(() => _idChecked = true);
        debugPrint('[CheckID] success -> _idChecked=$_idChecked');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('가입이 완료되었습니다. 계속 진행해주세요.')),
        );
      } else {
        setState(() => _error = '가입에 실패했습니다. (status: $status)');
        debugPrint('[CheckID][FAIL] errorText=$_error');
      }
    } catch (e, st) {
      if (!mounted) return;
      setState(() => _error = '요청 중 오류가 발생했습니다: $e');
      debugPrint('[CheckID][EX] $e\n$st');
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = '');

    debugPrint('[Submit] formValid=$_formValid '
        '(idChecked=$_idChecked, validId=$_validId, validPw=$_validPw, '
        'pwMatched=$_pwMatched, emailLocal=$_validEmailLocal, '
        'emailDomain=$_validEmailDomain, fullEmail=$_fullEmail)');

    if (!_formValid) {
      debugPrint('[Submit] aborted by _formValid=false');
      return;
    }

    try {
      final vm = Provider.of<AuthViewModel>(context, listen: false);

      debugPrint('[Submit] calling createPassword...');
      final status = await vm.createPassword(password: _pwController.text);
      debugPrint('[Submit] createPassword.status=$status');

      if (!mounted) return;

      if (status == 200 || status == 201) {
        debugPrint('[Submit] navigation -> /signup/complete (before)');
        context.go('/signup/complete');
        debugPrint('[Submit] navigation -> /signup/complete (after)');
      } else {
        setState(() => _error = '비밀번호 생성에 실패했습니다. (status: $status)');
        debugPrint('[Submit][FAIL] errorText=$_error');
      }
    } catch (e, st) {
      if (!mounted) return;
      setState(() => _error = '요청 중 오류가 발생했습니다: $e');
      debugPrint('[Submit][EX] $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: const Text('회원가입'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (_, c) => ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _FieldLabel('아이디'),
                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          controller: _idController,
                          hintText: '아이디',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                            LengthLimitingTextInputFormatter(12),
                          ],
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _checkIdDuplicated,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFD6DBE8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: Colors.black87,
                          ),
                          child: const Text('중복확인'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '4~12자/영문 소문자(숫자 조합 가능)',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  if (_idChecked)
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text('사용 가능한 아이디입니다.',
                          style: TextStyle(fontSize: 12, color: Colors.green)),
                    ),

                  const SizedBox(height: 20),
                  const _FieldLabel('비밀번호'),
                  _filledField(
                    controller: _pwController,
                    hintText: '비밀번호',
                    obscureText: _isPwObscure,
                    suffixIcon: IconButton(
                      icon: Icon(_isPwObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPwObscure = !_isPwObscure),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(12),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  _filledField(
                    controller: _pw2Controller,
                    hintText: '비밀번호 확인',
                    obscureText: _isPw2Obscure,
                    suffixIcon: IconButton(
                      icon: Icon(_isPw2Obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isPw2Obscure = !_isPw2Obscure),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(12),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '6~12자/영문, 숫자, 특수문자 중 2가지 이상 조합',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  if (_pwController.text.isNotEmpty && !_validPw)
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text('비밀번호 규칙을 확인해주세요.',
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                    ),
                  if (_pw2Controller.text.isNotEmpty && !_pwMatched)
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text('비밀번호가 일치하지 않습니다.',
                          style: TextStyle(fontSize: 12, color: Colors.red)),
                    ),

                  const SizedBox(height: 20),
                  const _FieldLabel('이메일'),
                  Row(
                    children: [
                      Expanded(
                        child: _filledField(
                          controller: _emailLocalController,
                          hintText: '이메일',
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Za-z0-9._%+\-]'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('@', style: TextStyle(fontSize: 18, color: Colors.black54)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _domainPicker(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '로그인 및 비밀번호 찾기에 사용할 이메일을 입력해주세요.',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  if (_validEmailLocal && _validEmailDomain)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(_fullEmail,
                          style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ),

                  const Spacer(),

                  if (_error.isNotEmpty) ...[
                    Text(_error, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _formValid ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        disabledBackgroundColor: const Color(0xFFCFD6FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('완료',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- widgets ----------
  Widget _filledField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: _hintColor),
        filled: true,
        fillColor: _fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _domainPicker() {
    if (_usingCustomDomain) {
      return _filledField(
        controller: _emailDomainCustomController,
        hintText: '직접입력',
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9.\-]')),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _fillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 48,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedDomain,
          items: _domains
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (v) => setState(() {
            _selectedDomain = v ?? '선택';
          }),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    );
  }
}
