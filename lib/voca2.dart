class Voca2 { // { 단어, 뜻, 예문 }
  final String word;
  final String meaning;

  Voca2({required this.word, required this.meaning});

  Map<String, dynamic> toJson() { // 객체를 _JsonMap 으로 encoding
    return {
      'word': word,
      'meaning': meaning,
    };
  }

  factory Voca2.fromJson(Map<String, dynamic> json) {
    return Voca2(
      word: json['word'],
      meaning: json['meaning'],
    );
  }
}