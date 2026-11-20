import 'package:my_cool_game/domain/entities/items/item.dart';

class Charcoal extends Item {
  Charcoal()
      : super(
          id: 'charcoal',
          name: 'Carbón',
          spritePath: 'item/charcoal.png',
        );
}
