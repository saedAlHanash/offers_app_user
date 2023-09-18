class ApiResponse<T> {
  final int offsetCount;
  final int count;
  final List<T> items;

  ApiResponse({
    required this.items,
    required this.offsetCount,
    required this.count,
  });
}
