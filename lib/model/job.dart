// model/job.dart
import 'package:flutter/material.dart';

class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String jobType; // '인턴', '신입', '경력'
  final String dDay;
  final String description;
  final String logoUrl;
  final bool isFavorite;
  final DateTime postedDate;
  final DateTime deadline;
  final List<String> tags;
  final String salaryInfo;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.dDay,
    required this.description,
    required this.logoUrl,
    required this.isFavorite,
    required this.postedDate,
    required this.deadline,
    required this.tags,
    required this.salaryInfo,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as int,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      dDay: json['dDay'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      postedDate: DateTime.parse(json['postedDate'] as String),
      deadline: DateTime.parse(json['deadline'] as String),
      tags: List<String>.from(json['tags'] as List? ?? []),
      salaryInfo: json['salaryInfo'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'jobType': jobType,
      'dDay': dDay,
      'description': description,
      'logoUrl': logoUrl,
      'isFavorite': isFavorite,
      'postedDate': postedDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'tags': tags,
      'salaryInfo': salaryInfo,
    };
  }

  Job copyWith({
    int? id,
    String? title,
    String? company,
    String? location,
    String? jobType,
    String? dDay,
    String? description,
    String? logoUrl,
    bool? isFavorite,
    DateTime? postedDate,
    DateTime? deadline,
    List<String>? tags,
    String? salaryInfo,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      dDay: dDay ?? this.dDay,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      tags: tags ?? this.tags,
      salaryInfo: salaryInfo ?? this.salaryInfo,
    );
  }

  // 채용 유형별 색상 반환
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