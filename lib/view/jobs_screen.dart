import 'package:flutter/material.dart';
import 'package:futurefinder_flutter/model/job_response.dart';
import 'package:futurefinder_flutter/viewmodel/job_viewmodel.dart';
import 'package:futurefinder_flutter/view/job_onboarding/job_onboarding_start_screen.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jobViewModel = context.read<JobViewModel>();
      jobViewModel.loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobViewModel>(
      builder: (context, jobViewModel, child) {
        // 사용자 정보가 없으면 온보딩 화면 표시 (수정된 조건)
        if ((jobViewModel.jobInfo == null ||
                jobViewModel.jobInfo!.educations.isEmpty) &&
            jobViewModel.educationData == null) {
          return const JobOnboardingStartScreen();
        }
        // 메인 일자리 화면
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              await jobViewModel.loadInitialData();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                _buildHeader(jobViewModel),
                const SizedBox(height: 20),
                _buildMyInfoCard(jobViewModel),
                const SizedBox(height: 30),

                // 로딩 상태 표시
                if (jobViewModel.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // 에러 메시지 표시
                if (jobViewModel.errorMessage != null)
                  _buildErrorCard(jobViewModel.errorMessage!, jobViewModel),

                // AI 매치 인턴 공고 섹션
                _buildSectionHeader(
                  title: 'AI 매치 인턴 공고',
                  onSeeAll: () {
                    debugPrint('AI 매치 인턴 공고 전체보기 클릭');
                  },
                ),
                const SizedBox(height: 16),
                ...jobViewModel.recommendedJobs.map(
                  (job) => _buildRecommendedJobItem(job),
                ),

                const SizedBox(height: 30),

                // 추천 대외활동 섹션
                _buildSectionHeader(
                  title: '추천 대외활동',
                  onSeeAll: () {
                    debugPrint('추천 대외활동 전체보기 클릭');
                  },
                ),
                const SizedBox(height: 16),
                _buildExtracurricularGrid(jobViewModel.recommendedActivities),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(JobViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.4,
            color: Colors.black,
          ),
          children: [
            TextSpan(text: '${viewModel.userName}을 위한\n맞춤 채용 정보를 추천드려요'),
            const TextSpan(text: ' 💡'),
          ],
        ),
      ),
    );
  }

  Widget _buildMyInfoCard(JobViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF00BFFF), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '내 정보',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey.shade400, size: 24),
            ],
          ),
          const SizedBox(height: 20),
          _buildCardInfoRow(label: '학력', value: viewModel.userEducation),
          const SizedBox(height: 12),
          _buildCardInfoRow(label: '활동', value: viewModel.userActivity),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow({required String label, required String value}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Text('|', style: TextStyle(color: Colors.grey[300], fontSize: 16)),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00BFFF),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required String title, VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Row(
            children: [
              Text(
                '전체보기',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedJobItem(RecommendedJobResponse job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // 좌측 태그들
          Column(
            children: [
              _buildTag(job.jobType, const Color(0xFF00BFFF), Colors.white),
              const SizedBox(height: 6),
              _buildTag(job.dDay, Colors.grey.shade200, Colors.grey.shade700),
            ],
          ),
          const SizedBox(width: 16),

          // 중앙 컨텐츠
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.company,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  job.title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          // 우측 즐겨찾기 (별표 없음)
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExtracurricularGrid(
    List<RecommendedActivityResponse> activities,
  ) {
    // 실제 추천 대외활동 더미 데이터 (이미지와 일치)
    final displayActivities = [
      {
        'title': 'POOM 서포터즈 5기',
        'subtitle': 'POOM 서포터즈 품어만 55기 모집',
        'organization': '주식회사 아트박스',
        'location': '지역 제한없음',
        'type': '브랜드',
        'color': Colors.blue.shade100,
      },
      {
        'title': 'CJ LOGISTICS 대학생 앰버서터',
        'subtitle': 'CJ LOGISTICS 대학생 앰버서터',
        'organization': 'CJ대한통운(주)',
        'location': '서울',
        'type': '기업',
        'color': Colors.green.shade100,
      },
      {
        'title': 'Digital Hana',
        'subtitle': 'Digital Hana',
        'organization': '하나은행',
        'location': '서울',
        'type': '금융',
        'color': Colors.orange.shade100,
      },
      {
        'title': '삼성 금융캠퍼스 1기',
        'subtitle': '삼성 금융캠퍼스 1기 모집(3일과정)',
        'organization': '삼성생명보험(주)',
        'location': '지역제한없음',
        'type': '교육',
        'color': Colors.purple.shade100,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: displayActivities.length,
      itemBuilder: (context, index) {
        final activity = displayActivities[index];
        return _buildExtracurricularCard(
          title: activity['title'] as String,
          subtitle: activity['subtitle'] as String,
          organization: activity['organization'] as String,
          location: activity['location'] as String,
          type: activity['type'] as String,
          backgroundColor: activity['color'] as Color,
        );
      },
    );
  }

  Widget _buildExtracurricularCard({
    required String title,
    required String subtitle,
    required String organization,
    required String location,
    required String type,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 메인 콘텐츠 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 (파란색 강조)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00BFFF),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // 조직명 (메인 타이틀)
                  Text(
                    organization,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // 하단 지역 정보
                  Text(
                    location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage, JobViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
          TextButton(
            onPressed: () => viewModel.clearError(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
