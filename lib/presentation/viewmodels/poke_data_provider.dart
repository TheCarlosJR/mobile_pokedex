import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_data_model.dart';
import 'package:pokedex/data/repositories/poke_data_repo.dart';

/// Estado da lista de Pokemons com dados
class PokeDataListState {
  final List<PokeDataModel> pokemons;
  final bool isLoading;
  final bool hasError;
  final bool hasNext;
  String? errorMsg;

  PokeDataListState({
    required this.pokemons,
    this.isLoading = false,
    this.hasError = false,
    this.hasNext = true,
    this.errorMsg,
  });

  PokeDataListState copyWith({
    List<PokeDataModel>? pokemons,
    bool? isLoading,
    bool? hasError,
    bool? hasNext,
    String? errorMsg,
  }) {
    return PokeDataListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      hasNext: hasNext ?? this.hasNext,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// Provider do repositorio (expoe PokeRepo a arvore de widgets - qualquer lugar do app pode acessar esse repositório via ref.watch(pokeRepoProvider))
final pokeRepoProvider = Provider((ref) => PokeDataRepo());

/// ViewModel (StateNotifier eh uma classe controladora que gerencia o estado de forma reativa)
class PokeDataListNotifier extends StateNotifier<PokeDataListState> {
  final PokeDataRepo repository;
  int _offset = 0;
  final int _limit = 20;

  PokeDataListNotifier(this.repository)
      : super(PokeDataListState(pokemons: []));

  Future<void> getPokemons(List<dynamic> urlList) async {
    if (state.isLoading || !state.hasNext) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final newPokemons = await repository.getPokemons(
        urlList: urlList,
        offset: _offset,
        limit: _limit,
      );

      state = state.copyWith(
        pokemons: [...state.pokemons, ...newPokemons],
        isLoading: false,
        hasNext: newPokemons.isNotEmpty,
      );

      _offset += _limit;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }

  /*
  /// Obtem dados de um pokemon pelo nome ou ID
  Future<void> getPokemon(String key) async {
    if (state.isLoading || !state.hasNext) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final newPokemon = await repository.getPokemon(key);

      state = state.copyWith(
        pokemons: [...state.pokemons, newPokemon],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }
  */
}

/// Provider do estado da lista (StateNotifierProvider conecta o StateNotifier ao Riverpod)
final pokeDataListNotifierProvider =
    StateNotifierProvider<PokeDataListNotifier, PokeDataListState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeDataListNotifier(repo);
});
