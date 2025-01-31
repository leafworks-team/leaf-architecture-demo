class PhotoEntity {
  final String id;
  final String url;
  final String thumbUrl;
  final String? description;

  PhotoEntity({required this.id, required this.url, required this.thumbUrl, this.description});
}
