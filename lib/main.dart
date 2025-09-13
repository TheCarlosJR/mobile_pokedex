import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/pages/home.dart';
import 'presentation/pages/details.dart';

void main() async {

  //pega o local correto pois cada SO tem o seu
  final dir = await getApplicationSupportDirectory();

  //inivializa hive
  Hive
    ..init(dir.path);
  //..registerAdapters();

  runApp(
    const ProviderScope(
      child: PokedexApp(),
    ),
  );
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
