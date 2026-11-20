/// Outside the web there is no browser speech. The turn falls back to taps.
Future<void> speak(String text) async {}

Future<String> listen() async => '__nosr__';
