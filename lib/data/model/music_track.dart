class MusicTrack {
  final int id;
  final String? music;
  final String? picture;
  final String? composer;
  final String? title;
  final String? long;

  const MusicTrack({
    required this.id,
    this.music,
    this.picture,
    this.composer,
    this.title,
    this.long,
  });
}
