import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_url_model.dart';
import 'package:pokedex/data/repositories/poke_url_repo.dart';

/// Estado da lista de Pokemons com dados
class PokeUrlListState {
  final List<PokeUrlModel> pokemons;
  final bool isLoading;
  final bool hasError;
  String? errorMsg;

  PokeUrlListState({
    required this.pokemons,
    this.isLoading = false,
    this.hasError = false,
    this.errorMsg,
  });

  PokeUrlListState copyWith({
    List<PokeUrlModel>? pokemons,
    bool? isLoading,
    bool? hasError,
    String? errorMsg,
  }) {
    return PokeUrlListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// Provider do repositorio (expoe PokeRepo a arvore de widgets - qualquer lugar do app pode acessar esse repositório via ref.watch(pokeRepoProvider))
final pokeRepoProvider = Provider((ref) => PokeUrlRepo());

/// ViewModel (StateNotifier eh uma classe controladora que gerencia o estado de forma reativa)
class PokeUrlListNotifier extends StateNotifier<PokeUrlListState> {
  final PokeUrlRepo repository;

  PokeUrlListNotifier(this.repository)
      : super(PokeUrlListState(pokemons: []));

  /// Obtem a lista de URLs de pokemons
  Future<void> getPokemons() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final newPokemons = await repository.getPokemons();

      state = state.copyWith(
        pokemons: newPokemons,
        isLoading: false,
      );

    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }
}

/// Provider do estado da lista (StateNotifierProvider conecta o StateNotifier ao Riverpod)
final pokeUrlListNotifierProvider =
StateNotifierProvider<PokeUrlListNotifier, PokeUrlListState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeUrlListNotifier(repo);
});
