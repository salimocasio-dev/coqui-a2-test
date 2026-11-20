import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:my_cool_game/domain/core/enums/game_progress.dart';
import 'package:my_cool_game/domain/core/globals.dart';

class GameProgressNotifier extends riverpod.Notifier<GameProgress> {
  @override
  GameProgress build() => GameProgress.menu;

  void updateProgress(GameProgress progress) => state = progress;

  List<Say> getAlchemistDialog() {
    switch (state) {
      case GameProgress.menu:
        return [];
      case GameProgress.start:
        return [
          Say(
            text: [
              const TextSpan(text: 'Hola, señora. ¿Necesita ayuda?'),
            ],
            personSayDirection: PersonSayDirection.LEFT,
            person: Globals.imageAssets.dwarf,
          ),
          Say(
            text: [
              const TextSpan(text: '¡Sí! Necesito '),
              Globals.imageAssets.charcoalText,
              const TextSpan(text: ' para hacer mi '),
              Globals.imageAssets.elixerText,
              const TextSpan(text: '.'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.alchemist,
          ),
          Say(
            text: [
              const TextSpan(text: '¡Claro que sí!'),
            ],
            personSayDirection: PersonSayDirection.LEFT,
            person: Globals.imageAssets.dwarf,
          ),
        ];
      case GameProgress.searching:
        return [
          Say(
            text: [
              const TextSpan(text: '¿Encontraste el '),
              Globals.imageAssets.charcoalText,
              const TextSpan(text: ' para mi '),
              Globals.imageAssets.elixerText,
              const TextSpan(text: '?'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.alchemist,
          ),
        ];
      case GameProgress.charcoalCollected:
        return [
          Say(
            text: [
              const TextSpan(text: '¡Lo encontraste! Ahora puedo hacer mi '),
              Globals.imageAssets.elixerText,
              const TextSpan(text: '.'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.alchemist,
          ),
          Say(
            text: [
              const TextSpan(
                text:
                    '¡Aquí está! ¿Se lo llevas a mi esposo, por favor?',
              ),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.alchemist,
          ),
        ];
      case GameProgress.elixerCollected:
        return [
          Say(
            text: [
              const TextSpan(
                text: '¡No hagas esperar a mi esposo, por favor!',
              ),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.alchemist,
          ),
        ];
    }
  }

  List<Say> getBlacksmithDialog() {
    switch (state) {
      case GameProgress.menu:
        return [];
      case GameProgress.start:
        return [
          Say(
            text: [
              const TextSpan(
                  text:
                      'Hola, muchacho. Creo que mi esposa necesita ayuda. ¿Puedes hablar con ella?'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.blacksmith,
          ),
        ];
      case GameProgress.searching:
        return [
          Say(
            text: [
              const TextSpan(text: 'A little blue bird told me you need some '),
              Globals.imageAssets.charcoalText,
              const TextSpan(text: '. Well here it is!'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.blacksmith,
          ),
        ];
      case GameProgress.charcoalCollected:
        return [
          Say(
            text: [
              const TextSpan(text: '¿Y qué esperas, muchacho?'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.blacksmith,
          ),
        ];
      case GameProgress.elixerCollected:
        return [
          Say(
            text: [
              const TextSpan(
                  text:
                      '¡Ay, gracias! ¡No sabes cuánto lo necesitaba!'),
            ],
            personSayDirection: PersonSayDirection.RIGHT,
            person: Globals.imageAssets.blacksmith,
          ),
        ];
    }
  }
}
