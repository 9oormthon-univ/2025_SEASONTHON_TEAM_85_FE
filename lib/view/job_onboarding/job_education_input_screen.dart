import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_activity_selection_screen.dart';
import 'package:futurefinder_flutter/viewmodel/job_viewmodel.dart';
import 'package:provider/provider.dart';

class JobEducationInputScreen extends StatefulWidget {
  const JobEducationInputScreen({super.key});

  @override
  State<JobEducationInputScreen> createState() =>
      _JobEducationInputScreenState();
}

class _JobEducationInputScreenState extends State<JobEducationInputScreen> {
  final _schoolController = TextEditingController();
  final _majorController = TextEditingController();
  final _statusController = TextEditingController();
  final _yearController = TextEditingController();

  bool get isFormValid {
    return _schoolController.text.isNotEmpty &&
        _majorController.text.isNotEmpty &&
        _statusController.text.isNotEmpty &&
        _yearController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '학업정보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '학업정보를 입력해주세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 32),

            // 학교명
            _buildInputField(
              label: '학교명',
              controller: _schoolController,
              hintText: '연세대학교',
            ),
            const SizedBox(height: 20),

            // 전공
            _buildInputField(
              label: '전공',
              controller: _majorController,
              hintText: '경영학과',
            ),
            const SizedBox(height: 20),

            // 학년/재학상태
            _buildInputField(
              label: '학년/재학상태',
              controller: _statusController,
              hintText: '3학년/재학중',
            ),
            const SizedBox(height: 20),

            // 졸업연도
            _buildInputField(
              label: '졸업연도',
              controller: _yearController,
              hintText: '2026년도',
            ),

            const Spacer(),

            // 완료 버튼
            ElevatedButton(
              onPressed: isFormValid
                  ? () {
                      _saveEducationAndNavigate(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFFF),
                disabledBackgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00BFFF)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _saveEducationAndNavigate(BuildContext context) {
    // JobViewModel에 교육 정보 저장
    final jobViewModel = context.read<JobViewModel>();

    Map<String, String> educationData = {
      'school': _schoolController.text,
      'major': _majorController.text,
      'status': _statusController.text,
      'year': _yearController.text,
    };

    jobViewModel.saveEducation(educationData);

    // 대외활동 선택 화면으로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const JobActivitySelectionScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _majorController.dispose();
    _statusController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
