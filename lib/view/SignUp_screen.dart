import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../viewmodel/auth_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birth6Controller = TextEditingController(); // YYMMDD
  final TextEditingController _birth1Controller = TextEditingController(); // 뒤 1자리
  final TextEditingController _phoneController = TextEditingController();   // 숫자만, 10~11자리

  // Focus
  final FocusNode _birth6Focus = FocusNode();
  final FocusNode _birth1Focus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  bool _isCompleted = false;
  String _error = '';

  static const _fillColor = Color.fromARGB(255, 236, 241, 248);
  static const _blue = Color(0xFF1737C4);

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_updateState);
    _nameController.addListener(_updateState);
    _birth6Controller.addListener(_onBirth6Changed);
    _birth1Controller.addListener(_updateState);
    _phoneController.addListener(_updateState);

    // ✅ 첫 진입 시, 이전에 남아있던 임시 가입 값 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthViewModel>().clearSignUpBasics(notify: false);
    });
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_updateState);
    _nameController.removeListener(_updateState);
    _birth6Controller.removeListener(_onBirth6Changed);
    _birth1Controller.removeListener(_updateState);
    _phoneController.removeListener(_updateState);

    _nicknameController.dispose();
    _nameController.dispose();
    _birth6Controller.dispose();
    _birth1Controller.dispose();
    _phoneController.dispose();

    _birth6Focus.dispose();
    _birth1Focus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  // listeners
  void _onBirth6Changed() {
    _updateState();
    if (_birth6Controller.text.length == 6) {
      _birth1Focus.requestFocus();
    }
  }

  void _updateState() {
    setState(() {
      _isCompleted =
          _nicknameController.text.trim().isNotEmpty &&
              _nameController.text.trim().isNotEmpty &&
              _birth6Controller.text.length == 6 &&
              _isValidYYMMDD(_birth6Controller.text) &&
              _birth1Controller.text.length == 1 &&
              _isValidPhone(_phoneController.text);
    });
  }

  // validators
  bool _isValidYYMMDD(String v) {
    if (v.length != 6) return false;
    final yy = int.tryParse(v.substring(0, 2));
    final mm = int.tryParse(v.substring(2, 4));
    final dd = int.tryParse(v.substring(4, 6));
    if (yy == null || mm == null || dd == null) return false;
    if (mm < 1 || mm > 12) return false;
    final daysInMonth = <int>[
      31,
      _isLeap(yy) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return dd >= 1 && dd <= daysInMonth[mm - 1];
  }

  bool _isLeap(int yy) => yy % 4 == 0;

  bool _isValidPhone(String v) {
    // 숫자 10~11자리 (예: 01012345678)
    final digitsOnly = RegExp(r'^\d{10,11}$');
    return digitsOnly.hasMatch(v);
  }

  // actions
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final vm = Provider.of<AuthViewModel>(context, listen: false);
    vm.setSignUpBasics(
      nickname: _nicknameController.text.trim(),
      name: _nameController.text.trim(),
      birth6: _birth6Controller.text,
      birth1: _birth1Controller.text,
      phone: _phoneController.text,
    );

    context.push('/signup/account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (_, c) => ConstrainedBox(
              constraints: BoxConstraints(minHeight: c.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),

                  // 닉네임
                  const _FieldLabel('닉네임'),
                  _filledTextField(
                    controller: _nicknameController,
                    hintText: '닉네임입력',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // 이름
                  const _FieldLabel('이름'),
                  _filledTextField(
                    controller: _nameController,
                    hintText: '이름입력',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // 생년월일
                  const _FieldLabel('생년월일'),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: _filledTextField(
                          controller: _birth6Controller,
                          hintText: '6자리 입력',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          focusNode: _birth6Focus,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('-', style: TextStyle(fontSize: 18, color: Colors.black54)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 44,
                        child: _filledTextField(
                          controller: _birth1Controller,
                          hintText: '0',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          focusNode: _birth1Focus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _phoneFocus.requestFocus(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 점 표시(시각 가이드)
                      Expanded(
                        child: Row(
                          children: List.generate(
                            6,
                                (_) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFBDBDBD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 휴대폰번호
                  const _FieldLabel('휴대폰번호'),
                  _filledTextField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    hintText: '휴대폰 번호입력',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _isCompleted ? _submit() : null,
                  ),

                  const Spacer(),

                  if (_error.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_error, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),

                  // 완료 버튼
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isCompleted ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue,
                        disabledBackgroundColor: const Color(0xFFCFD6FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '완료',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
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

  // common input
  Widget _filledTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFB8B8B8)),
        filled: true,
        fillColor: _fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
