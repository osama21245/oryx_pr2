
class WalkThroughModel {
  String? image;
  String? title;
  String? title1;
  String? title2;

  WalkThroughModel({this.image, this.title,this.title1,this.title2});
}
class IntroLanguageModel {
  String name;
  String code;
  String flagImage;
  String countryCode;

  IntroLanguageModel({
    required this.name,
    required this.code,
    required this.flagImage,
    required this.countryCode,
  });
}