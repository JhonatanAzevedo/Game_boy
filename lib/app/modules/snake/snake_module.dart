import 'package:flutter_modular/flutter_modular.dart';
import 'presentation/snake_page.dart';

class SnakeModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (ctx, args) => const SnakePage()),
      ];
}