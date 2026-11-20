import 'dart:js_interop';

@JS('coquiSpeak')
external JSPromise<JSAny?> _coquiSpeak(JSString text);

@JS('coquiListen')
external JSPromise<JSString> _coquiListen();

/// Says [text] in Spanish with the browser's voice. Finishes when it is done.
Future<void> speak(String text) async {
  try {
    await _coquiSpeak(text.toJS).toDart;
  } catch (_) {}
}

/// Listens once. Returns the heard alternatives joined by '|',
/// '' for silence, '__nosr__' with no recognition, '__err__:<code>' on error.
Future<String> listen() async {
  try {
    final result = await _coquiListen().toDart;
    return result.toDart;
  } catch (e) {
    return '__err__:$e';
  }
}
