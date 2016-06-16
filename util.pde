void flushIds() {
  PrintWriter outputId = createWriter("idLog.txt");
  outputId.flush();
  outputId.close();
}

String capitalise(String str) {
  return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
}

String getRegex(String str) {
  String regex = "";
  for (int i = 0; i < str.length(); i++) {
    regex += "[" + Character.toLowerCase(str.charAt(i)) + Character.toUpperCase(str.charAt(i)) + "]";
  }
  return regex;
}