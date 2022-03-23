enum StreamPlatform { youtube, twitch, facebook, other }

class StreamDestination {
  final StreamPlatform platform;
  final String url;

  StreamDestination({
    required this.platform,
    required this.url,
  });
}
