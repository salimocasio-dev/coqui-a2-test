// Coquí A2 test: a spoken turn with a character.
//
// The character says a line (browser voice, with the words on screen).
// The player answers out loud. The answer is matched by key words:
// - a right answer moves on,
// - a known wrong answer gets the character's reply and another try,
// - anything not understood gets "¿Cómo?" and another try. A mishear never costs.
//
// "Opciones" on: the two answers show as text (mode 1).
// "Opciones" off: nothing shows; he builds the answer himself (mode 2).

import 'package:flutter/material.dart';

import 'speech.dart';

class SpokenOption {
  const SpokenOption({
    required this.text,
    required this.keys,
    this.right = false,
    this.reply,
  });

  /// What shows on screen in mode 1.
  final String text;

  /// Any of these words heard means this option.
  final List<String> keys;

  final bool right;

  /// What the character says back to a wrong answer.
  final String? reply;
}

class SpokenTurn {
  const SpokenTurn({required this.line, required this.options, this.ask});

  final String line;

  /// The question alone, repeated after "¿Cómo?". Defaults to [line].
  final String? ask;
  final List<SpokenOption> options;
}

class SpeakTurnDialog extends StatefulWidget {
  const SpeakTurnDialog({
    super.key,
    required this.name,
    required this.portrait,
    required this.turns,
    required this.closing,
  });

  final String name;
  final Widget portrait;
  final List<SpokenTurn> turns;

  /// What the character says once every turn is answered.
  final String closing;

  /// Shows the turns. Returns true when every turn was answered right.
  static Future<bool> show(
    BuildContext context, {
    required String name,
    required Widget portrait,
    required List<SpokenTurn> turns,
    required String closing,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SpeakTurnDialog(
        name: name,
        portrait: portrait,
        turns: turns,
        closing: closing,
      ),
    );
    return result ?? false;
  }

  /// Remembered for the whole visit.
  static bool showOptions = true;

  @override
  State<SpeakTurnDialog> createState() => _SpeakTurnDialogState();
}

enum _Phase { talking, waiting, listening, done }

class _SpeakTurnDialogState extends State<SpeakTurnDialog> {
  int _turn = 0;
  _Phase _phase = _Phase.talking;
  late String _shown;
  String _heard = '';
  bool _noRecognition = false;
  String _problem = '';

  SpokenTurn get _current => widget.turns[_turn];

  @override
  void initState() {
    super.initState();
    _shown = _current.line;
    WidgetsBinding.instance.addPostFrameCallback((_) => _say(_current.line));
  }

  Future<void> _say(String text) async {
    if (!mounted) return;
    setState(() {
      _shown = text;
      _phase = _Phase.talking;
    });
    await speak(text);
    if (!mounted) return;
    if (_phase == _Phase.talking) setState(() => _phase = _Phase.waiting);
  }

  static String _norm(String s) {
    const from = 'áéíóúüñ';
    const to = 'aeiouun';
    final lower = s.toLowerCase();
    final out = StringBuffer();
    for (final ch in lower.split('')) {
      final i = from.indexOf(ch);
      out.write(i >= 0 ? to[i] : ch);
    }
    return out.toString().replaceAll(RegExp(r'[^a-z ]'), ' ');
  }

  SpokenOption? _match(String heard) {
    final alternatives = heard.split('|').map(_norm).toList();
    for (final alt in alternatives) {
      final words = alt.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
      for (final option in _current.options) {
        for (final key in option.keys) {
          final k = _norm(key).trim();
          if (k.contains(' ') ? alt.contains(k) : words.contains(k)) {
            return option;
          }
        }
      }
    }
    return null;
  }

  Future<void> _listen() async {
    if (_phase == _Phase.listening) return;
    setState(() {
      _phase = _Phase.listening;
      _heard = '';
      _problem = '';
    });
    final result = await listen();
    if (!mounted) return;

    if (result == '__nosr__') {
      setState(() {
        _noRecognition = true;
        _phase = _Phase.waiting;
        _problem = 'Este navegador no puede oírte. Toca tu respuesta.';
      });
      return;
    }
    if (result.startsWith('__err__')) {
      final code = result.substring(8);
      setState(() {
        _phase = _Phase.waiting;
        _problem = code.contains('not-allowed')
            ? 'Permite el micrófono para hablar.'
            : (code.contains('no-speech') ? '' : 'Error: $code');
      });
      if (!code.contains('not-allowed')) {
        await _say('¿Cómo? ${_current.ask ?? _current.line}');
      }
      return;
    }

    setState(() => _heard = result.split('|').first);
    await _answer(_match(result));
  }

  Future<void> _answer(SpokenOption? option) async {
    if (option == null) {
      await _say('¿Cómo? ${_current.ask ?? _current.line}');
      return;
    }
    if (!option.right) {
      await _say(option.reply ?? 'No. ¿Qué dijiste?');
      return;
    }
    if (_turn + 1 < widget.turns.length) {
      setState(() {
        _turn++;
        _heard = '';
      });
      await _say(_current.line);
      return;
    }
    await _say(widget.closing);
    if (!mounted) return;
    setState(() => _phase = _Phase.done);
  }

  @override
  Widget build(BuildContext context) {
    final showOptions = SpeakTurnDialog.showOptions || _noRecognition;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: const Color(0xFF1E1A16),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 56, height: 56, child: widget.portrait),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: Color(0xFFE8B04A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _shown,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Oír otra vez',
                      onPressed: _phase == _Phase.listening
                          ? null
                          : () => _say(_shown),
                      icon: const Icon(Icons.volume_up, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_phase != _Phase.done && showOptions)
                  ..._current.options.map(
                    (o) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _noRecognition
                          ? OutlinedButton(
                              onPressed: () => _answer(o),
                              child: Text(o.text,
                                  style: const TextStyle(fontSize: 18)),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '“${o.text}”',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                    ),
                  ),
                if (_heard.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: Text(
                      'Oí: “$_heard”',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                if (_problem.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _problem,
                      style: const TextStyle(color: Color(0xFFFF8A80)),
                    ),
                  ),
                const SizedBox(height: 8),
                if (_phase == _Phase.done)
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Seguir', style: TextStyle(fontSize: 18)),
                  )
                else if (!_noRecognition)
                  SizedBox(
                    height: 64,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: _phase == _Phase.listening
                            ? const Color(0xFFC62828)
                            : const Color(0xFF2E7D32),
                      ),
                      onPressed: _phase == _Phase.listening ? null : _listen,
                      icon: Icon(
                        _phase == _Phase.listening ? Icons.hearing : Icons.mic,
                        size: 28,
                      ),
                      label: Text(
                        _phase == _Phase.listening ? 'Escuchando…' : 'Habla',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Switch(
                      value: SpeakTurnDialog.showOptions,
                      onChanged: (v) =>
                          setState(() => SpeakTurnDialog.showOptions = v),
                    ),
                    Text('Opciones',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
