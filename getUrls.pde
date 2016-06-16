String[] getUrls() {
  String[] oldIds = loadStrings("idLog.txt");
  HashMap<String, Integer> idCheck = new HashMap<String, Integer>();
  if (oldIds != null) {
    for (int i = 0; i < oldIds.length; i++) {
      idCheck.put(oldIds[i], 0);
    }
  }
  StringList list = new StringList();
  XML rss = loadXML(rssFeed);
  XML[] ids = rss.getChildren("entry/id");
  XML[] links = rss.getChildren("entry/link");
  PrintWriter outputId = createWriter("idLog.txt");
  for (int i = 0; i < ids.length; i++) {
    String idStr = ids[i].getContent();
    String[] idNo = match(idStr, ".*feed:(.+)");
    idStr = idNo[1];
    outputId.println(idStr);
    if (!idCheck.containsKey(idStr)) {
      String href = readUrl(links[i]);
      list.append(href);
    }
  }
  outputId.flush();
  outputId.close();
  return list.array();
}

String readUrl(XML link) {
  String xmlHref = link.getString("href");
  String[] lines = loadStrings(xmlHref);
  String googlehtml = join(lines, "");
  String[] innerurl = match(googlehtml, "content=\"0;URL='(.*?)'\"></noscript");
  return innerurl[1];
}