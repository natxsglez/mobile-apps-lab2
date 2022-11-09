class PlatformModel {
  final String platformName;
  final String url;

  PlatformModel({required this.platformName, required this.url});

  PlatformModel.fromMap(Map<String, dynamic> item)
      : platformName = item['platformName'],
        url = item['url'];
}
