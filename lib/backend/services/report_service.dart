import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:campus_trace/backend/models/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createReport(ReportModel report) async {
    try {
      // Use document() to auto-generate an ID if reportId is empty, or use the provided one
      final docRef = _firestore.collection('reports').doc();
      final newReport = ReportModel(
        reportId: docRef.id,
        userId: report.userId,
        userName: report.userName,
        userEmail: report.userEmail,
        type: report.type,
        title: report.title,
        description: report.description,
        category: report.category,
        location: report.location,
        reportDate: report.reportDate,
        imageUrl: report.imageUrl,
        status: report.status,
        isRecovered: report.isRecovered,
        createdAt: report.createdAt,
        updatedAt: report.updatedAt,
      );
      await docRef.set(newReport.toMap());
      debugPrint('Successfully created report: ${docRef.id}');
    } catch (e, stackTrace) {
      debugPrint('Error creating report: $e\n$stackTrace');
      throw Exception('Failed to create report.');
    }
  }

  Stream<List<ReportModel>> getAllReports() {
    debugPrint('Executing ReportService.getAllReports()...');
    return _firestore
        .collection('reports')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      debugPrint('getAllReports snapshot received ${snapshot.docs.length} docs.');
      final reports = snapshot.docs.map((doc) => ReportModel.fromMap(doc.data(), doc.id)).toList();
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }

  Stream<List<ReportModel>> getUserReports(String uid) {
    debugPrint('Executing ReportService.getUserReports(uid: $uid)...');
    return _firestore
        .collection('reports')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      debugPrint('getUserReports snapshot received ${snapshot.docs.length} docs for user $uid.');
      final reports = snapshot.docs.map((doc) => ReportModel.fromMap(doc.data(), doc.id)).toList();
      reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return reports;
    });
  }

  Future<void> markRecovered(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': 'recovered',
        'isRecovered': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('Successfully marked report $reportId as recovered.');
    } catch (e, stackTrace) {
      debugPrint('Error marking report as recovered: $e\n$stackTrace');
      throw Exception('Failed to mark as recovered.');
    }
  }

  Future<void> archiveReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': 'archived',
        'updatedAt': DateTime.now().toIso8601String(),
      });
      debugPrint('Successfully archived report $reportId.');
    } catch (e, stackTrace) {
      debugPrint('Error archiving report: $e\n$stackTrace');
      throw Exception('Failed to archive report.');
    }
  }

  Future<Map<String, dynamic>> getUserReportStats(String uid) async {
    try {
      final querySnapshot = await _firestore
          .collection('reports')
          .where('userId', isEqualTo: uid)
          .get();

      int totalReports = querySnapshot.docs.length;
      int itemsRecovered = querySnapshot.docs.where((doc) {
        return doc.data()['isRecovered'] == true;
      }).length;

      double recoveryRate = 0.0;
      if (totalReports > 0) {
        recoveryRate = (itemsRecovered / totalReports) * 100;
      }

      return {
        'reportsSubmitted': totalReports,
        'itemsRecovered': itemsRecovered,
        'recoveryRate': recoveryRate.round(),
      };
    } catch (e, stackTrace) {
      debugPrint('Error getting user report stats: $e\n$stackTrace');
      return {
        'reportsSubmitted': 0,
        'itemsRecovered': 0,
        'recoveryRate': 0,
      };
    }
  }

  Future<Map<String, dynamic>> getPlatformReportStats() async {
    try {
      final querySnapshot = await _firestore.collection('reports').get();

      int totalReports = querySnapshot.docs.length;
      int itemsRecovered = querySnapshot.docs.where((doc) {
        return doc.data()['isRecovered'] == true;
      }).length;

      double recoveryRate = 0.0;
      if (totalReports > 0) {
        recoveryRate = (itemsRecovered / totalReports) * 100;
      }

      return {
        'reportsSubmitted': totalReports,
        'itemsRecovered': itemsRecovered,
        'recoveryRate': recoveryRate.round(),
      };
    } catch (e, stackTrace) {
      debugPrint('Error getting platform report stats: $e\n$stackTrace');
      return {
        'reportsSubmitted': 0,
        'itemsRecovered': 0,
        'recoveryRate': 0,
      };
    }
  }
}
