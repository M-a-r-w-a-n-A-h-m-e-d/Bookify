class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final String stars;
  final String description;
  final String payment;
  final String image;
  final List<Map<String, String>> availableTime;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.stars,
    required this.description,
    required this.payment,
    required this.image,
    required this.availableTime,
  });

  // Create a Doctor from a Map
  factory Doctor.fromJson(Map<String, dynamic> json) {
    var availableTimeList = json['availableTime'] as List;
    List<Map<String, String>> availableTime =
        availableTimeList.map((e) => Map<String, String>.from(e)).toList();

    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      experience: json['experience'],
      stars: json['stars'],
      description: json['description'],
      payment: json['payment'],
      image: json['image'],
      availableTime: availableTime,
    );
  }
}
