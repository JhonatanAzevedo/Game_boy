import 'package:flutter_modular/flutter_modular.dart';

import '../pacman/pacman_module.dart';
import '../snake/snake_module.dart';
import 'presentation/home_page.dart';

class HomeModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (ctx, args) => const HomePage()),
        ModuleRoute("/pacman", module: PacManModule()),
        ModuleRoute("/snake", module: SnakeModule()),
      ];
}
