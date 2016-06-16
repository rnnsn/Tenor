String[] getSentences(String[] paragraphs) {
  String[] sentences = fetchSentences(paragraphs);
  String[] selectedSentences = containsKeyword(sentences);
  for (int i = 0; i < selectedSentences.length; i++) {
    selectedSentences[i] = convertUnicode(selectedSentences[i]);
  }
  return selectedSentences;
}

String[] fetchSentences(String[] str) {
  StringBuilder sb = new StringBuilder();
  StringList list = new StringList();
  for (int i = 0; i < str.length; i++) {
    if (match(str[i], "[0-9A-z]$") != null) {
      str[i] += ".";
    }
    String[] words = splitTokens(str[i]);
    for (int j = 0; j < words.length; j++) {
      sb.append(words[j]);
      if (match(words[j], "[.…?!][\")]*$") != null || j == words.length - 1) {
        list.append(sb.toString());
        sb.setLength(0);
      } else {
        sb.append(" ");
      }
    }
  }
  return list.array();
}

String[] containsKeyword(String[] sentences) {
  StringList list = new StringList();
  for (int i = 0; i < sentences.length; i++) {
    String str = sentences[i];
    if (str.contains(" ") && ((matchAll(str, "[\\[{(|]") == null || matchAll(str, "[\\[{(|]").length < 3)) && (str.contains(keyword) || str.contains(keyCap) || str.contains(keyAllCap))) {
      String[][] pre = matchAll(str, "([0-9A-Za-z-])" + keyRegexCapt);
      if (pre != null) {
        for (int j = 0; j < pre.length; j++) {
          if (pre[j][1].equals("-")) {
            str = str.replaceAll(pre[j][0], " " + pre[j][2]);
          } else {
            str = str.replaceAll(pre[j][0], pre[j][1] + " " + pre[j][2]);
          }
        }
      }
      String[][] post = matchAll(str, keyRegexCapt + "([0-9A-Za-z-])");
      if (post != null) {
        for (int j = 0; j < post.length; j++) {
          if (post[j][2].equals("-")) {
            str = str.replaceAll(post[j][0], post[j][1] + " ");
          } else {
            str = str.replaceAll(post[j][0], post[j][1] + " " + post[j][2]);
          }
        }
      }
      str = str.replaceAll("  ", " ");
      str = str.trim();
      list.append(str);
    }
  }
  return list.array();
}

String convertUnicode(String str) {
  str = str.replaceAll("(&hellip;|\\.\\.\\.|&#8230;)", "…");
  str = str.replaceAll("&(amp|#038);", "&");
  str = str.replaceAll("&(pound|#163);", "£");
  str = str.replaceAll("&(ndash|#8211);", "–");
  str = str.replaceAll("&(mdash|#8212|#x2014|#151);", "—");
  str = str.replaceAll("&#43;", "+");
  str = str.replaceAll("&ntilde;", "n");
  str = str.replaceAll("&ccedil;", "c");
  str = str.replaceAll("&uuml;", "u");
  str = str.replaceAll("&euml;", "e");
  str = str.replaceAll("&(nbsp|#0*160|#32|#032|#xA0);", " ");
  str = str.replaceAll("(&([lr]squo|apos|#0*39|#821[67]|#x*2019);*|[‘’])", "'");
  str = str.replaceAll("(&(quot|#822[01]|#x*201[cCdD]|[lr]dquo);*|[“”])", "\"");
  str = str.replaceAll("ﬀ", "ff");
  str = str.replaceAll("&(gt|rs*aquo);", ">");
  str = str.replaceAll("&(lt|ls*aquo);", "<");
  str = str.replaceAll("&laquo;", "«");
  str = str.replaceAll("&raquo;", "»");
  str = str.replaceAll("&(copy|#169);", "©");
  str = str.replaceAll("&reg;", "®");
  str = str.replaceAll("&trade;", "™");
  str = str.replaceAll("&#x5c;", "/");
  str = str.replaceAll("&(#x2022|[rl]arr|bull|middot);", "");
  do {
    str = str.replaceAll("  ", " ");
  } while (str.contains("  "));
  str = str.replaceAll("&[^ ]+?;", "");
  str = str.trim();
  return str;
}