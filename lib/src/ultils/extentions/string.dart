extension StringX on String {
  firstUperCase() => '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}
