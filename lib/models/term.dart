class Term {
  final int id;
  final String label;
  final String value;

  Term({required this.id,
    required this.label,
    required this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      id: int.parse(json['id'].toString()),
      label: json['label'].toString(),
      value: json['value'].toString(),
    );
  }
}
