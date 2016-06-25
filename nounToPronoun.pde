String[] nounToPronoun(String[] sentences) {
  sentences = adjustGrammar(sentences);
  sentences = replaceKeyword(sentences);
  return sentences;
}

String[] adjustGrammar(String[] sentences) {
  for (int i = 0; i < sentences.length; i++) {
    String str = sentences[i];

    str = str.replaceAll("n't ", " nOt ");

    /// nouns
    str = replacePos(str, "(?:jj|vbn)+ cc (?:jj|nn|vbn)+ KEY", "RM RM RM KEY");
    str = replacePos(str, "(?:jj|nn|vbn)+ KEY", "RM KEY");
    str = replacePos(str, "KEY nn+ (?!rb)", "KEY RM (?!rb)");
    str = replacePos(str, "KEY nn $", "KEY RM $");
    str = replacePos(str, "KEY vb[ng] (?:vb|nn) vbg*", "KEY RM RM RM");

    /// possessives
    str = replacePos(str, "prp KEY", "RM KEY");
    str = replacePos(str, "dt KEY prp vb", "RM KEY RM RM");
    str = replacePos(str, "dt KEY $", "RM KEY $");
    str = replacePos(str, "dt KEY", "RM KEY");
    str = replacePos(str, "vb in KEY $", "vb RM KEY $");
    str = replacePos(str, "vb in KEY (?!vb)", "vb RM KEY (?!vb)");

    /// quantity
    str = replacePos(str, "rb dt KEY", "rb dt of_KEY");
    str = replacePos(str, "(?:one|ONE|One|1)/cd KEY", "(?:one|ONE|One|1)/cd of_KEY");
    str = replacePos(str, "cd KEY", "cd pieces_of_KEY");

    /// and/about
    str = replacePos(str, "KEY cc . (?!dt) vb", "KEY RM RM (?!dt) vb");
    str = replacePos(str, "KEY cc . $", "KEY RM RM $");
    str = replacePos(str, "KEY vb .+ cc vbz", "KEY vb .+ cc vb");
    str = replacePos(str, "KEY in dt vb", "KEY RM RM vb");

    /// verbs (conjugation)
    str = replacePos(str, "^ in* KEY rb* (?:vbz|vbd)", "^ in* KEY rb* vb");
    str = replacePos(str, "(?:vb|rb|cc) in KEY vbz", "(?:vb|rb|cc) in KEY vb");
    str = replacePos(str, "wrb .* KEY rb* vbz", "wrb .* KEY rb* vb");
    str = replacePos(str, "(?!in) vbz KEY vb", "(?!in) vb KEY vb");

    /// yourself
    str = replacePos(str, "KEY vb KEY", "KEY vb KEYrself");

    str = str.replaceAll(" nOt ", "n't ");

    if (match(str, "^" + keyRegex) != null) {
      str = str.substring(0, 1).toUpperCase() + str.substring(1);
    }
    sentences[i] = str;
  }

  return sentences;
}

String[] replaceKeyword(String[] str) {
  for (int i = 0; i < str.length; i++) {
    str[i] = str[i].replaceAll("\\b" + keyword + "\\b", newWord);
    str[i] = str[i].replaceAll("\\b" + keyCap + "\\b", capitalise(newWord));
    str[i] = str[i].replaceAll("\\b" + keyAllCap + "\\b", newWord.toUpperCase());
    str[i] = str[i].replaceAll(keyRegex, newWord);
  }
  return str;
}