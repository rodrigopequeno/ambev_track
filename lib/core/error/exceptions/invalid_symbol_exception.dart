class InvalidSymbolException implements Exception {
  final String symbol;
  InvalidSymbolException({
    required this.symbol,
  });
  @override
  String toString() {
    return "InvalidSymbol: $symbol";
  }
}
