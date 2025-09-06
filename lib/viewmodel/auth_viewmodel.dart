import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/dto/auth_dto.dart';
import 'package:futurefinder_flutter/exception/api_exception.dart';
import 'package:futurefinder_flutter/model/user.dart';
import 'package:futurefinder_flutter/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthViewModel(this._authRepository);

  // 1단계 임시 저장값
  // 임시 저장값(프라이빗)
  String? _signupNickname;
  String? _signupName;
  String? _signupBirth6;
  String? _signupBirth1;
  String? _signupPhone;

  // ✅ public getter 추가
  String? get signupNickname => _signupNickname;
  String? get signupName => _signupName;
  String? get signupBirth6 => _signupBirth6;
  String? get signupBirth1 => _signupBirth1;
  String? get signupPhone  => _signupPhone;

  // setter (1단계에서 호출)
  void setSignUpBasics({
    required String nickname,
    required String name,
    required String birth6,
    required String birth1,
    required String phone,
    bool notify = true,
  }) {
    _signupNickname = nickname.trim();
    _signupName = name.trim();
    _signupBirth6 = birth6;
    _signupBirth1 = birth1;
    _signupPhone = phone;
    if (notify) notifyListeners();
  }

// ✅ 저장된 값으로 회원가입 호출 + 상세 로그
  Future<int> signUpWithSavedBasics({
    required String accountId,
    String deviceId = 'device-abc-123',
    String provider = 'ios',
    String appToken = 'testpushtoken',
  }) async {
    // 현재 보관 중인 임시값 로깅
    debugPrint('[SignUp] draft -> '
        'nick=${_signupNickname}, name=${_signupName}, '
        'birth=${_signupBirth6}-${_signupBirth1}, phone=${_signupPhone}');

    if (_signupName == null || _signupNickname == null) {
      debugPrint('[SignUp][ERROR] signup basics not set');
      throw StateError('signup basics not set');
    }

    final req = SignUpRequest(
      accountId: accountId,
      userName: _signupName!,    // 서버 스펙: userName, nickName
      nickName: _signupNickname!,
      deviceId: deviceId,
      provider: provider,
      appToken: appToken,
    );

    // 요청 직전 입력 파라미터 로깅
    debugPrint('[SignUp] request -> '
        'accountId=$accountId, userName=${_signupName}, nickName=${_signupNickname}, '
        'deviceId=$deviceId, provider=$provider, appToken=$appToken');

    // (선택) DTO JSON 확인
    try {
      debugPrint('[SignUp] request.json = ${req.toJson()}');
    } catch (_) {
      // toJson 없거나 예외면 무시
    }

    try {
      final status = await _authRepository.signUp(req);
      debugPrint('[SignUp] response.status = $status '
          '(토큰은 저장되었지만 값은 로그에 남기지 않음)');
      return status; // 200 기대
    } on ApiException catch (e, st) {
      debugPrint('[SignUp][ApiException] status=${e.status} '
          'code=${e.errorCode} msg=${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('[SignUp][Unhandled] $e');
      // kDebugMode && debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  // (선택) 완료/취소 시 임시값 지우기
  void clearSignUpBasics({bool notify = true}) {
    _signupNickname = null;
    _signupName = null;
    _signupBirth6 = null;
    _signupBirth1 = null;
    _signupPhone = null;
    if (notify) notifyListeners();
  }


  // ✅ 비밀번호 생성 호출
  Future<int> createPassword({required String password}) async {
    final req = CreatePasswordRequest(password: password);
    final status = await _authRepository.createPassword(req);
    return status; // 200 기대
  }


  Future<void> fetchData() async {
    await fetchUserProfile();
    debugPrint("User profile fetched: ${_currentUser?.nickname}");
  }

  Future<void> fetchUserProfile() async {
    try {
      _currentUser = await _authRepository.getProfile();
    } on ApiException catch (e) {
      try {
        await _authRepository.refreshAccessToken();
        _currentUser = await _authRepository.getProfile();
      } catch (e) {
        rethrow;
      }
    }

    notifyListeners();
  }

  Future<int> login({
    required String accountId,
    required String password,
    required String deviceId,
    required String provider,
  }) async {
    LoginRequest request = LoginRequest(
      accountId: accountId,
      password: password,
      deviceId: deviceId,
      provider: provider,
      appToken: "push-token-abcdef",
    );

    return await _authRepository.login(request);
  }
}
