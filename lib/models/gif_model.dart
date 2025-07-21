class GifResponse {
  String? url;
  GifResponse({this.url});
  GifResponse.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
}
