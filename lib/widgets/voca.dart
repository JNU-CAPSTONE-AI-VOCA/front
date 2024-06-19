class Voca { // { 단어, 뜻, 예문 }
  final String word;
  final String meaning;
  final String sentence; // sentence

  Voca({required this.word, required this.meaning, required this.sentence});

  Map<String, dynamic> toJson() { // 객체를 _JsonMap 으로 encoding
    return {
      'word': word,
      'meaning': meaning,
      'sentence': sentence,
    };
  }

  factory Voca.fromJson(Map<String, dynamic> json) {
    return Voca(
      word: json['word'],
      meaning: json['meaning'],
      sentence: json['sentence'],
    );
  }
}