class Faculty {
  final String name;
  final double latitude;
  final double longitude;
  final String category;

  Faculty({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.category,
  });

  static List<Faculty> unsoedFaculties = [
    Faculty(name: 'Faperta', latitude: -7.408285, longitude: 109.253603, category: 'Agriculture'),
    Faculty(name: 'Fabio', latitude: -7.409414, longitude: 109.254140, category: 'Biology'),
    Faculty(name: 'FEB', latitude: -7.404143, longitude: 109.247542, category: 'Economics'),
    Faculty(name: 'Fapet', latitude: -7.406548, longitude: 109.252880, category: 'Animal Science'),
    Faculty(name: 'Hukum', latitude: -7.405029, longitude: 109.247498, category: 'Law'),
    Faculty(name: 'Fisip', latitude: -7.402242, longitude: 109.246248, category: 'Social & Political'),
    Faculty(name: 'Kedokteran', latitude: -7.434252, longitude: 109.267900, category: 'Medicine'),
    Faculty(name: 'Teknik', latitude: -7.428807, longitude: 109.336432, category: 'Engineering'),
    Faculty(name: 'FIB', latitude: -7.405615, longitude: 109.252603, category: 'Humanities'),
    Faculty(name: 'Fikes', latitude: -7.409901, longitude: 109.252219, category: 'Health Sciences'),
    Faculty(name: 'MIPA', latitude: -7.407483, longitude: 109.253687, category: 'Science'),
    Faculty(name: 'FPIK', latitude: -7.410134, longitude: 109.250892, category: 'Fisheries'),
  ];
}