import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDashboardScreen extends StatelessWidget {
  final Student student;

  const StudentDashboardScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<StudentCourse>> coursesBySemester = {};
    for (final course in student.courses) {
      coursesBySemester.putIfAbsent(course.semNo, () => []).add(course);
    }

    final List<String> sortedSemesters = coursesBySemester.keys.toList()
      ..sort((a, b) {
        final int? aNum = int.tryParse(a);
        final int? bNum = int.tryParse(b);
        if (aNum != null && bNum != null) {
          return aNum.compareTo(bNum);
        }
        return a.compareTo(b);
      });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Seat No: ${student.seatNo}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    _buildInfoRow('Father Name', student.fatherName),
                    _buildInfoRow('Department', student.departmentName),
                    _buildInfoRow('Enrollment No', student.enrollmentNo),
                    _buildInfoRow('Class', student.className),
                    _buildInfoRow('Faculty', student.faculty),
                    _buildInfoRow('Semester', student.semNo),
                    _buildInfoRow('Class Year', student.classYear),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...sortedSemesters.map((semester) {
              final courses = coursesBySemester[semester]!;
              return _buildSemesterSection(semester, courses);
            }).toList(),
            if (student.cgpr != null) ...[
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CGPR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (student.cgpr != null)
                            Expanded(
                              child: _buildStatusCard(
                                'CGPR',
                                student.cgpr!.toStringAsFixed(2),
                                Colors.black87,
                              ),
                            ),
                          if (student.cgpr != null &&
                              student.percentage != null)
                            const SizedBox(width: 12),
                          if (student.percentage != null)
                            Expanded(
                              child: _buildStatusCard(
                                'Percentage',
                                student.percentage!.toStringAsFixed(2),
                                Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(String semester, List<StudentCourse> courses) {
    final StudentCourse sample = courses.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semester $semester - Academic Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        'GPA',
                        sample.result.toStringAsFixed(1),
                        Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatusCard(
                        'Status',
                        sample.promote,
                        Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        'Courses Cleared',
                        sample.clearCourses,
                        Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatusCard(
                        'Total Courses',
                        sample.fixedCourses,
                        Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semester $semester - Course Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return _buildCourseCard(course);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCourseCard(StudentCourse course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  course.courseTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildCourseInfo('CourseNo', course.courseNo),
              const SizedBox(width: 16),
              _buildCourseInfo('Credits', '${course.creditHours}'),
              const SizedBox(width: 16),
              _buildCourseInfo('Marks', '${course.totalMarks}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildCourseInfo('Theory', '${course.terminalMarks}'),
              if (course.extTerminal != null) ...[
                const SizedBox(width: 16),
                _buildCourseInfo('Lab', '${course.extTerminal}'),
              ],
              const SizedBox(width: 16),
              _buildCourseInfo('GPA', course.gradePoint.toStringAsFixed(1)),
              const SizedBox(width: 16),
              _buildCourseInfo('Grade', course.gradeRatio),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
