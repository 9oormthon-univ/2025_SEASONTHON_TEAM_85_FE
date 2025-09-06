// model/job_response.dart
import 'package:flutter/material.dart';

// AI 추천 채용공고 응답
class RecommendedJobResponse {
  final int id;
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String deadline;
  final String description;
  final String logoUrl;
  final List<String> tags;
  final String salaryInfo;

  const RecommendedJobResponse({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.deadline,
    required this.description,
    required this.logoUrl,
    required this.tags,
    required this.salaryInfo,
  });

  factory RecommendedJobResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedJobResponse(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      jobType: json['jobType'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      tags: List<String>.from(json['tags'] as List? ?? []),
      salaryInfo: json['salaryInfo'] as String? ?? '',
    );
  }

  // D-Day 계산
  String get dDay {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      final difference = deadlineDate.difference(now).inDays;
      
      if (difference < 0) return '마감';
      if (difference == 0) return 'D-DAY';
      return 'D-$difference';
    } catch (e) {
      return 'D-?';
    }
  }

  // 채용 유형별 색상
  Color get jobTypeColor {
    switch (jobType) {
      case '인턴':
        return Colors.cyan.shade600;
      case '신입':
        return Colors.blue.shade600;
      case '경력':
        return Colors.purple.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Color get jobTypeBackgroundColor {
    switch (jobType) {
      case '인턴':
        return Colors.cyan.shade50;
      case '신입':
        return Colors.blue.shade50;
      case '경력':
        return Colors.purple.shade50;
      default:
        return Colors.grey.shade50;
    }
  }
}

// AI 추천 대외활동 응답
class RecommendedActivityResponse {
  final int id;
  final String title;
  final String organization;
  final String location;
  final String type;
  final String deadline;
  final String description;
  final String logoUrl;
  final List<String> tags;

  const RecommendedActivityResponse({
    required this.id,
    required this.title,
    required this.organization,
    required this.location,
    required this.type,
    required this.deadline,
    required this.description,
    required this.logoUrl,
    required this.tags,
  });

  factory RecommendedActivityResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedActivityResponse(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      location: json['location'] as String? ?? '',
      type: json['type'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  // 활동 유형별 색상
  Color get typeColor {
    switch (type) {
      case '브랜드':
        return Colors.blue.shade100;
      case '기업':
        return Colors.green.shade100;
      case '금융':
        return Colors.orange.shade100;
      case '교육':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

// 취업 관련 정보 전체 응답
class JobInfoResponse {
  final List<EducationResponse> educations;
  final List<ActivityResponse> activities;
  final List<AwardResponse> awards;

  const JobInfoResponse({
    required this.educations,
    required this.activities,
    required this.awards,
  });

  factory JobInfoResponse.fromJson(Map<String, dynamic> json) {
    return JobInfoResponse(
      educations: (json['educations'] as List? ?? [])
          .map((e) => EducationResponse.fromJson(e))
          .toList(),
      activities: (json['activities'] as List? ?? [])
          .map((a) => ActivityResponse.fromJson(a))
          .toList(),
      awards: (json['awards'] as List? ?? [])
          .map((a) => AwardResponse.fromJson(a))
          .toList(),
    );
  }
}

// 학력 정보 응답
class EducationResponse {
  final int id;
  final String schoolName;
  final String major;
  final String status;
  final int graduationYear;

  const EducationResponse({
    required this.id,
    required this.schoolName,
    required this.major,
    required this.status,
    required this.graduationYear,
  });

  factory EducationResponse.fromJson(Map<String, dynamic> json) {
    return EducationResponse(
      id: json['id'] as int? ?? 0,
      schoolName: json['schoolName'] as String? ?? '',
      major: json['major'] as String? ?? '',
      status: json['status'] as String? ?? '',
      graduationYear: json['graduationYear'] as int? ?? 0,
    );
  }
}

// 대외활동 응답 (백엔드 DTO에 맞춤)
class ActivityResponse {
  final int id;
  final String type; // ActivityType enum이지만 String으로 받음
  final String title;
  final String startedAt; // LocalDate -> String
  final String endedAt;   // LocalDate -> String
  final String memo;

  const ActivityResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.startedAt,
    required this.endedAt,
    required this.memo,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      id: json['id'] as int? ?? 0,
      type: json['type'].toString(), // enum을 String으로 변환
      title: json['title'] as String? ?? '',
      startedAt: json['startedAt'] as String? ?? '',
      endedAt: json['endedAt'] as String? ?? '',
      memo: json['memo'] as String? ?? '',
    );
  }
}

// 수상 내역 응답 (백엔드 DTO에 맞춤)
class AwardResponse {
  final int id;
  final String awardName;
  final String organization;
  final String awardedOn; // LocalDate -> String
  final String description;

  const AwardResponse({
    required this.id,
    required this.awardName,
    required this.organization,
    required this.awardedOn,
    required this.description,
  });

  factory AwardResponse.fromJson(Map<String, dynamic> json) {
    return AwardResponse(
      id: json['id'] as int? ?? 0,
      awardName: json['awardName'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      awardedOn: json['awardedOn'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}