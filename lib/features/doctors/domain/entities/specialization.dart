class Specialization {
  final int id;
  final String name;
  final String? description;
  final String? icon;

  const Specialization({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });
}
