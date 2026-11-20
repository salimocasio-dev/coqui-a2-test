import 'speak_turn.dart';

/// The Blacksmith's spoken turns: he asks, the player answers out loud.
const blacksmithTurns = <SpokenTurn>[
        SpokenTurn(
          line: 'Hola otra vez, muchacho. ¿Qué necesitas?',
          ask: '¿Qué necesitas?',
          options: [
            SpokenOption(
              text: 'Necesito carbón.',
              keys: ['carbon', 'carbono'],
              right: true,
            ),
            SpokenOption(
              text: 'Necesito una espada.',
              keys: ['espada', 'espadas'],
              reply: '¿Una espada? Hoy no tengo espadas. ¿Qué más necesitas?',
            ),
          ],
        ),
        SpokenTurn(
          line: '¿Carbón? Bueno. ¿Y quién te mandó?',
          ask: '¿Quién te mandó?',
          options: [
            SpokenOption(
              text: 'Tu esposa.',
              keys: ['esposa', 'mujer', 'alquimista', 'senora'],
              right: true,
            ),
            SpokenOption(
              text: 'El rey.',
              keys: ['rey'],
              reply: '¿El rey? Yo no conozco al rey. ¿Quién te mandó?',
            ),
          ],
        ),
      ];

const blacksmithClosing = 'Ah, mi esposa. Bueno, aquí tienes el carbón.';
