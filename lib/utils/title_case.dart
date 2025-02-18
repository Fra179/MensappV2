extension TitleCase on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
