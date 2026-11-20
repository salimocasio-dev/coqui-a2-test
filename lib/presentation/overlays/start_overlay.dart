import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_cool_game/coqui/blacksmith_turns.dart';
import 'package:my_cool_game/coqui/speak_turn.dart';
import 'package:my_cool_game/domain/core/globals.dart';
import 'package:my_cool_game/presentation/components/adventure_style_text.dart';
import 'package:my_cool_game/presentation/overlays/overlay_container.dart';

class StartOverlay extends StatelessWidget {
  final void Function() onStart;

  const StartOverlay({
    required this.onStart,
    super.key,
  });

  @override
  Widget build(BuildContext context) => OverlayContainer(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blueAccent.shade100,
                    Colors.blueAccent.shade700
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AdventureStyleText('Coqui A2'),
                  const Gap(32),
                  ElevatedButton(
                    onPressed: onStart,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Start',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  const Gap(16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    onPressed: () => SpeakTurnDialog.show(
                      context,
                      name: 'El herrero',
                      portrait: Globals.imageAssets.blacksmith,
                      turns: blacksmithTurns,
                      closing: blacksmithClosing,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Hablar con el herrero ya',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
