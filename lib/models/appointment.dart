
class Appointment {
  int? id;
  String name;
  String dateOfBirth;
  String gender;
  String purpose;

  Appointment({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.purpose,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'purpose': purpose,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      name: map['name'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      purpose: map['purpose'],
    );
  }
}