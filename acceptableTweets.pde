String[] acceptableTweets(String[] sentences) {
  StringList tweets = new StringList();
  int tweetLimit = 85;
  for (int i = 0; i < sentences.length; i++) {

    String str = sentences[i];
    String pos = RiTa.getPosTagsInline(str);
    pos = pos.replaceAll(newRegex + "[^ ]*?/[^ ]+? ", "");

    if (match(pos, " [^ ]+?/nnps*") != null) {
      //exclude excessive proper nouns
    } else if (match(str, "https*://") != null || match(str, "[^ ]+?\\.[A-Za-z]+?/[^ ]*?") != null || match(str, "[^ ]+?\\.com\\b") != null) {
      //exclude urls
    } else if (match(str, "[@#$][A-Za-z0-9_]+?\\b") != null) {
      //exclude #hashtags, @replies, $tags
    } else if (matchAll(str, ",") != null && matchAll(str, ",").length > 3) {
      //exclude lists
    } else if (str.length() < 140 && tweetLimit > 0 && str.contains(" ")) {
      //acceptable tweet length
      tweets.append(str);
      tweetLimit--;
    }
  }
  return tweets.array();
}