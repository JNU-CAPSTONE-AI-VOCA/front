class Voca2 { // { 단어, 뜻 }
  final String word;
  final String meaning;

  Voca2({required this.word, required this.meaning});

  Map<String, dynamic> toJson() {
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