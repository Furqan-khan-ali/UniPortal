class StudentCourse {
  final String seatNo;
  final String semNo;
  final String name;
  final String sex;
  final String fatherName;
  final String departmentName;
  final String enrollmentNo;
  final String className;
  final String faculty;
  final String courseNo;
  final int creditHours;
  final String creditHour1;
  final String creditHour2;
  final int terminalMarks;
  final String? extTerminal;
  final int totalMarks;
  final String gradeRatio;
  final double gradePoint;
  final String courseTitle;
  final String username;
  final String classYear;
  final String finalRemarks;
  final String expr1;
  final double result;
  final String promote;
  final String clearCourses;
  final String fixedCourses;
  final double? cgpr;
  final double? percentage;

  StudentCourse({
    required this.seatNo,
    required this.semNo,
    required this.name,
    required this.sex,
    required this.fatherName,
    required this.departmentName,
    required this.enrollmentNo,
    required this.className,
    required this.faculty,
    required this.courseNo,
    required this.creditHours,
    required this.creditHour1,
    required this.creditHour2,
    required this.terminalMarks,
    this.extTerminal,
    required this.totalMarks,
    required this.gradeRatio,
    required this.gradePoint,
    required this.courseTitle,
    required this.username,
    required this.classYear,
    required this.finalRemarks,
    required this.expr1,
    required this.result,
    required this.promote,
    required this.clearCourses,
    required this.fixedCourses,
    this.cgpr,
    this.percentage,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    final dynamic cgprSource = json['PASSFAIL.CGPR'] ?? json['CGPR'];
    final dynamic percentageSource = json['PERCEN'] ?? json['PASSFAIL.PERCEN'];

    return StudentCourse(
      seatNo: json['SEATNO'] ?? '',
      semNo: json['SEMNO'] ?? '',
      name: json['NAME'] ?? '',
      sex: json['SEX'] ?? '',
      fatherName: json['FNAME'] ?? '',
      departmentName: json['DEPT_NAME'] ?? '',
      enrollmentNo: json['ENRNO'] ?? '',
      className: json['CLASS_NAME'] ?? '',
      faculty: json['FACULTY'] ?? '',
      courseNo: json['COURSENO'] ?? '',
      creditHours: int.tryParse(json['CH']?.toString() ?? '0') ?? 0,
      creditHour1: json['CREDITHOUR1']?.toString() ?? '0',
      creditHour2: json['CREDITHOUR2']?.toString() ?? '0',
      terminalMarks: int.tryParse(json['TERMINAL']?.toString() ?? '0') ?? 0,
      extTerminal: json['EXT_TERMINAL']?.toString(),
      totalMarks: int.tryParse(json['TOTALMARKS']?.toString() ?? '0') ?? 0,
      gradeRatio: json['GRATIO'] ?? '',
      gradePoint: double.tryParse(json['GPOINT']?.toString() ?? '0') ?? 0.0,
      courseTitle: json['COURSETITEL'] ?? '',
      username: json['USERNAME'] ?? '',
      classYear: json['CLASSYEAR'] ?? '',
      finalRemarks: json['FINALREMARKS'] ?? '',
      expr1: json['Expr1']?.toString() ?? '0',
      result: double.tryParse(json['RESULT']?.toString() ?? '0') ?? 0.0,
      promote: json['PROMOTE'] ?? '',
      clearCourses: json['CLEARCOURSES']?.toString() ?? '0',
      fixedCourses: json['FIXEDCOURSES']?.toString() ?? '0',
      cgpr: cgprSource != null ? double.tryParse(cgprSource.toString()) : null,
      percentage: percentageSource != null
          ? double.tryParse(percentageSource.toString())
          : null,
    );
  }
}

class Student {
  final String seatNo;
  final String name;
  final String fatherName;
  final String departmentName;
  final String enrollmentNo;
  final String className;
  final String faculty;
  final String semNo;
  final String classYear;
  final String promote;
  final String clearCourses;
  final String fixedCourses;
  final double result;
  final List<StudentCourse> courses;
  final double? cgpr;
  final double? percentage;

  Student({
    required this.seatNo,
    required this.name,
    required this.fatherName,
    required this.departmentName,
    required this.enrollmentNo,
    required this.className,
    required this.faculty,
    required this.semNo,
    required this.classYear,
    required this.promote,
    required this.clearCourses,
    required this.fixedCourses,
    required this.result,
    required this.courses,
    this.cgpr,
    this.percentage,
  });

  factory Student.fromCourseList(List<StudentCourse> courses) {
    if (courses.isEmpty) {
      throw ArgumentError('Course list cannot be empty');
    }

    final firstCourse = courses.first;
    double? overallCgpr;
    double? overallPercentage;

    for (final c in courses) {
      overallCgpr ??= c.cgpr;
      overallPercentage ??= c.percentage;
      if (overallCgpr != null && overallPercentage != null) {
        break;
      }
    }

    return Student(
      seatNo: firstCourse.seatNo,
      name: firstCourse.name,
      fatherName: firstCourse.fatherName,
      departmentName: firstCourse.departmentName,
      enrollmentNo: firstCourse.enrollmentNo,
      className: firstCourse.className,
      faculty: firstCourse.faculty,
      semNo: firstCourse.semNo,
      classYear: firstCourse.classYear,
      promote: firstCourse.promote,
      clearCourses: firstCourse.clearCourses,
      fixedCourses: firstCourse.fixedCourses,
      result: firstCourse.result,
      courses: courses,
      cgpr: overallCgpr,
      percentage: overallPercentage,
    );
  }
}
