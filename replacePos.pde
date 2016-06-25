RiLexicon lexicon = new RiLexicon();
HashMap person = new HashMap();

void conjugate() {
  person.put("person", RiTa.SECOND_PERSON);
}

String replacePos(String sentence, String find, String replace) {
  conjugate();
  String[] findList = find.split(" ");
  String[] replaceList = replace.split(" ");
  if (findList.length == replaceList.length) {
    String[] section = sentence.split("[^a-zA-Z0-9' -]");
    section = trim(section);
    for (int i = 0; i < section.length; i++) {
      if (match(section[i], keyRegex) != null) {
        String[][] strList = getFind(section[i], find);
        if (strList != null) {
          for (int x = 0; x < strList.length; x++) {
            String findStr = "";
            for (int j = 1; j < strList[x].length; j++) {
              findStr += strList[x][j] + " ";
            }
            findStr = findStr.trim();
            findStr = findStr.replaceAll("  ", " ");
            if (findStr != "") {
              String replaceStr = getReplace(strList[x], findList, replaceList);
              replaceStr = replaceStr.replaceAll("  ", " ");
              if (replaceStr != "") {
                String newSection = section[i].replaceAll(findStr, replaceStr);
                sentence = sentence.replaceAll(section[i], newSection);
                section[i] = newSection;
              }
            }
          }
        }
      }
    }
  }
  return sentence;
}

String[][] getFind(String section, String find) {
  String posInline = RiTa.getPosTagsInline(section);
  posInline += " ";
  String regex = posRegex(find);
  String[][] captureWords = matchAll(posInline, regex);
  if (captureWords != null) {
    for (int i = 0; i < captureWords.length; i++) {
      for (int j = 1; j < captureWords[0].length; j++) {
        captureWords[i][j] = captureWords[i][j].replaceAll("/[^ ]* ", " ");
        captureWords[i][j] = captureWords[i][j].trim();
      }
    }
    return captureWords;
  }
  return null;
}

String posRegex(String pos) {
  String[] tags = pos.split(" ");
  String regex = "";
  for (int i = 0; i < tags.length; i++) {
    if (tags[i].contains("KEY")) {
      regex += "(" + keyRegex + "[^ ]*?/[^ ]+? )";
    } else if (tags[i].equals(".+")) {
      regex += "((?:[^ ]*?/[^ ]* )+?)";
    } else if (tags[i].equals(".*")) {
      regex += "((?:[^ ]*?/[^ ]* )*?)";
    } else if (tags[i].equals("$")) {
      regex += "()$";
    } else if (tags[i].equals("^")) {
      regex += "^()";
    } else if (tags[i].equals("prp$")) {
      regex += "([^ ]*?/prp\\$ )";
    } else if (tags[i].equals("wp$")) {
      regex += "([^ ]*?/wp\\$ )";
    } else if (tags[i].contains("/")) {
      regex += "(\\b"  + tags[i] + "[^ ]* )";
    } else if (tags[i].contains("+")) {
      tags[i] = tags[i].replaceAll("\\+", "");
      regex += "((?:[^ ]*?/"  + tags[i] + "[^ ]* )+)";
    } else if (tags[i].contains("*")) {
      tags[i] = tags[i].replaceAll("\\*", "");
      regex += "((?:[^ ]*?/"  + tags[i] + "[^ ]* )*)";
    } else {
      regex += "([^ ]*?/"  + tags[i] + "[^ ]* )";
    }
  }
  return regex;
}

String getReplace(String strList[], String[] findList, String[] replaceList) {
  String replaceStr = "";
  for (int i = 0; i < findList.length; i++) {
    if (findList[i].contains("KEY") && replaceList[i].contains("KEY")) {
      replaceStr += replaceList[i].replaceAll("KEY", strList[i+1]).replaceAll("_", " ") + " ";
    } else if (replaceList[i].equals("RM")) {
      //
    } else if (replaceList[i].equals(".+") || replaceList[i].equals(".*") || replaceList[i].equals(".")) {
      replaceStr += strList[i+1] + " ";
    } else if (!findList[i].equals(replaceList[i])) {
      String newPos = changePos(strList[i+1], findList[i], replaceList[i]);
      if (newPos != "") {
        replaceStr += newPos + " ";
      }
    } else {
      replaceStr += strList[i+1] + " ";
    }
  }
  replaceStr = replaceStr.trim();
  return replaceStr;
}

String changePos(String word, String pos, String target) {
  String newWord = "";
  if (pos.equals("nns") && target.equals("nn")) {
    newWord = RiTa.stem(word);
  } else if (match(pos, "vb[zgnd]") != null && target.equals("vb")) {
    newWord = word.toLowerCase();
    if (newWord.equals("has")) {
      newWord = "have";
    } else if (newWord.equals("was")) {
      newWord = "were";
    } else if (newWord.equals("does")) {
      newWord = "do";
    } else {
      newWord = RiTa.stem(newWord);
      newWord = RiTa.conjugate(newWord, person);
      if (!lexicon.isVerb(newWord)) {
        if (lexicon.isVerb(newWord + "e")) {
          newWord = newWord + "e";
        } else if (lexicon.isVerb(newWord.substring(0, newWord.length()-1) + "y")) {
          newWord = newWord.substring(0, newWord.length()-1) + "y";
        } else if (lexicon.isVerb(newWord + "ate")) {
          newWord = newWord + "ate";
        }
      }
    }
  }
  newWord = correctCase(word, newWord);
  return newWord;
}

String correctCase(String original, String replica) {
  int capitalCounter = 0;
  for (int i = 0; i < original.length(); i++) {
    if (Character.isUpperCase(original.charAt(i))) {
      capitalCounter++;
    }
  }
  if (capitalCounter == original.length()) {
    replica = replica.toUpperCase();
  } else if (Character.isUpperCase(original.charAt(0))) {
    replica = capitalise(replica);
  }
  return replica;
}