import 'package:my_cool_game/domain/entities/items/item.dart';

class Elixer extends Item {
  Elixer()
      : super(
          id: 'elixer',
          name: 'Elixir',
          spritePath: 'item/elixer.png',
        );
}
