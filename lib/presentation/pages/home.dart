import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/repositories/poke_url_repo.dart';
import 'package:pokedex/data/repositories/poke_data_repo.dart';
import 'package:pokedex/presentation/viewmodels/poke_url_provider.dart';
import 'package:pokedex/presentation/viewmodels/poke_data_provider.dart';
import 'package:pokedex/presentation/widgets/mini_card.dart';
import 'package:pokedex/presentation/widgets/mini_load_card.dart';
import 'package:pokedex/presentation/pages/details.dart';

/// Tela inicial
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final urlList;

  final ScrollController _scrollController = ScrollController();

  /// Provider que armazena a query busca do TextField
  final pokeSearchProvider = StateProvider<String>((ref) => '');

  /// Provider que armazena o estado do textfield para visivel (true) ou nao
  final pokeShowSearchProvider = StateProvider<bool>((ref) => false);

  /// Fecha e oculta o teclado de pesquisa
  void closeSearchText() {
    ref.read(pokeSearchProvider.notifier).state = '';
    ref.read(pokeShowSearchProvider.notifier).state = false;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(
        () async {
          //obtem a lista completa de pokemons (nome e url)
          await ref.read(pokeUrlListNotifierProvider.notifier).getPokemons();
          urlList = ref.watch(pokeUrlListNotifierProvider).pokemons;

          //obtem os primeiros dados basicos de pokemons (nome, tipo, etc)
          await ref.read(pokeDataListNotifierProvider.notifier).getPokemons(urlList);
        });

    // Faz com que carregue mais pokemons da API se chegar no fim do scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(pokeDataListNotifierProvider.notifier).getPokemons(urlList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //estado da lista de pokemons
    final state = ref.watch(pokeDataListNotifierProvider);

    //se estado tem algum erro
    if (state.hasError) {
      return const Center(
        child: Text('Erro ao carregar API!'),
      );
    }

    //observa a query de busca do TextField
    final searchQuery = ref.watch(pokeSearchProvider).toLowerCase();

    //observa o estado do TextField
    final showSearchTextField = ref.watch(pokeShowSearchProvider);

    //filtra o Map pelo texto digitado (otimizado)
    final filteredPokemons = searchQuery.isEmpty
        ? state.pokemons
        : state.pokemons.where((entry) =>
          ((entry.name.toLowerCase().contains(searchQuery)) || (entry.id.toString().toLowerCase().contains(searchQuery)))
        ).toList(); //TODO mudar isso

    //procura tambem na API
    if (searchQuery.isNotEmpty) {
      //ref.read(pokeListNotifierProvider.notifier).getPokemon(searchQuery);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pokedex API'),
        backgroundColor: const Color(0xFFE0E0E0),
        actions: !state.isLoading
            ? [
                if (showSearchTextField) ...[
                  SizedBox(
                    width: 220,
                    child: TextField(
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Pokemon pelo Nome ou ID',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(pokeSearchProvider.notifier).state = value;
                      },
                      onTapOutside: (pointer) {
                        closeSearchText();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_off_outlined),
                    onPressed: closeSearchText,
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.search_outlined),
                    onPressed: () {
                      ref.read(pokeShowSearchProvider.notifier).state = true;
                    },
                  ),
                ],
              ]
            : [],
      ),
      body: Stack(
        children: [
          Positioned(
            left: -40,
            top: -35,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'lib/assets/pokeball-banner-maratuna-dark.png',
                width: 300,
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: -35,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'lib/assets/pokeball-banner-maratuna-dark.png',
                width: 300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.3,
              ),
              itemCount: filteredPokemons.length +
                  (state.isLoading ? (filteredPokemons.isEmpty ? 20 : 2) : 0),
              itemBuilder: (context, index) {
                if (index < filteredPokemons.length) {
                  final pokemon = filteredPokemons[index];
                  return MiniCard(
                    key: ValueKey(pokemon.id),
                    pokemon: pokemon,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            pokemon: pokemon,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  //constroi itens a mais para mostrar carregamento
                  return const MiniLoadCard();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
