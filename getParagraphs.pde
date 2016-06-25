String[] getParagraphs(String[] urls) {
  String[] html = loadHtml(urls);
  String[] paragraphs = getPtags(html);
  return paragraphs;
}

String[] loadHtml(String[] urls) {
  StringBuilder sb = new StringBuilder();
  StringList list = new StringList();
  for (int i = urls.length-1; i > -1; i--) {
    if (match(urls[i], "https*:.*?\\.pdf") == null) {
      try {
        URL url = new URL(urls[i]);
        URLConnection conn = url.openConnection();
        conn.setConnectTimeout(1000);
        conn.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:25.0) Gecko/20100101 Firefox/25.0");
        InputStreamReader in = new InputStreamReader(conn.getInputStream(), "UTF-8");
        BufferedReader br = new BufferedReader(in);
        String htmlText;
        while ((htmlText = br.readLine()) != null) {
          if (match(htmlText, "%PDF") != null) {
            break;
          }
          sb.append(htmlText + " ");
        }
      }
      catch (MalformedURLException e) {
        e.printStackTrace();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
      list.append(sb.toString());
      sb.setLength(0);
    }
  }
  return list.array();
}

String[] getPtags(String[] html) {
  StringList list = new StringList();
  for (int i = 0; i < html.length; i++) {
    html[i] = html[i].replaceAll("<style[^<>]*?>.*?</style>", "");
    html[i] = html[i].replaceAll("<script[^<>]*?>.*?</script>", "");
    String[][] ptag = matchAll(html[i], " *?<p\\b.*?>(.*?)</p>");
    if (ptag != null) {
      for (int j = 0; j < ptag.length; j++) {
        String p = ptag[j][1];
        p = p.replaceAll("<(span|a)[^<>]*?>", "");
        p = p.replaceAll("</(span|a)>", "");
        p = p.replaceAll("<[^<>]*?>", " ");
        p = p.replaceAll("<.*?>", " ");
        p = p.replaceAll("https*://.*? ", " ");
        p = p.replaceAll("…", "...");
        p = p.replaceAll(" \\.", ".");
        p = p.replaceAll("  ", " ");
        list.append(p);
      }
    }
  }
  return list.array();
}