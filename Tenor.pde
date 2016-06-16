import java.io.*;
import java.net.*;
import rita.*;

String keyword = "data"; //noun
String newWord = "you"; //pronoun
String rssFeed = "https://www.google.co.uk/alerts/feeds/10627392107163297101/15700763739085934447";

void setup() {
  //flushIds();
  String[] urls = getUrls();
  String[] paragraphs = getParagraphs(urls);
  String[] sentences = getSentences(paragraphs);
  sentences = nounToPronoun(sentences);
  String[] tweets = acceptableTweets(sentences);

  PrintWriter output = createWriter("tweets.txt");
  for (int i = 0; i < tweets.length; i++) {
    output.println(tweets[i]);
  }
  output.flush();
  output.close();
  println("DONE!");
  exit();
}

String keyCap = capitalise(keyword);
String keyAllCap = keyword.toUpperCase();
String keyRegex = getRegex(keyword);
String keyRegexCapt = "(" + keyRegex + ")";
String newRegex = getRegex(newWord);