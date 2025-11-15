double? latitudeFromIndex(String index) {
  if (index.length < 4) return null; // Prevent crash
  int firstTwo = int.tryParse(index.substring(0, 2)) ?? 0;
  return 5 + (firstTwo / 10.0);
}

double? longitudeFromIndex(String index) {
  if (index.length < 4) return null; // Prevent crash
  int nextTwo = int.tryParse(index.substring(2, 4)) ?? 0;
  return 79 + (nextTwo / 10.0);
}
