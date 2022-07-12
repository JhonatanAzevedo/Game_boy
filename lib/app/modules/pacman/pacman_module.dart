import 'package:flutter_modular/flutter_modular.dart';
import 'presentation/pac_man_page.dart';

class PacManModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (ctx, args) => const PacMan()),
      ];
}