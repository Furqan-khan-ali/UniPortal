import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.110:5000';
  //static const String baseUrl = 'http://192.168.1.100:5000';
  //static const String baseUrl = 'http://localhost:5000';
  //static const String baseUrl =
  //'https://sherell-diverse-unsententiously.ngrok-free.dev';

  static Future<List<StudentCourse>> getStudentData(String seatNo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?seatno=$seatNo'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => StudentCourse.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load student data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching student data: $e');
    }
  }

  static Future<Student> getStudent(String seatNo) async {
    try {
      final courses = await getStudentData(seatNo);
      return Student.fromCourseList(courses);
    } catch (e) {
      throw Exception('Error creating student object: $e');
    }
  }
}
