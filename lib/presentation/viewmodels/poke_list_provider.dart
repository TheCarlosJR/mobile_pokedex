import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_list_model.dart';
import 'package:pokedex/data/repositories/poke_list_repo.dart';

/// Estado da lista de Pokemons com dados
class PokeListState {
  final List<PokeListModel> pokemons;
  final bool isLoading;
  final bool hasError;
  final bool hasNext;
  String? errorMsg;

  PokeListState({
    required this.pokemons,
    this.isLoading = false,
    this.hasError = false,
    this.hasNext = true,
    this.errorMsg,
  });

  PokeListState copyWith({
    List<PokeListModel>? pokemons,
    bool? isLoading,
    bool? hasError,
    bool? hasNext,
    String? errorMsg,
  }) {
    return PokeListState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      hasNext: hasNext ?? this.hasNext,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// Provider do repositorio (expoe PokeRepo a arvore de widgets - qualquer lugar do app pode acessar esse repositório via ref.watch(pokeRepoProvider))
final pokeRepoProvider = Provider((ref) => PokeRepo());

/// ViewModel (StateNotifier eh uma classe controladora que gerencia o estado de forma reativa)
class PokeListNotifier extends StateNotifier<PokeListState> {
  final PokeRepo repository;
  int _offset = 0;
  final int _limit = 20;

  PokeListNotifier(this.repository)
      : super(PokeListState(pokemons: []));

  Future<void> loadPokemons() async {
    if (state.isLoading || !state.hasNext) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final newPokemons = await repository.getPokemons(offset: _offset, limit: _limit);

      state = state.copyWith(
        pokemons: [...state.pokemons, ...newPokemons],
        isLoading: false,
        hasNext: newPokemons.isNotEmpty,
      );

      _offset += _limit;
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }

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
}

/// Provider do estado da lista (StateNotifierProvider conecta o StateNotifier ao Riverpod)
final pokeListNotifierProvider =
StateNotifierProvider<PokeListNotifier, PokeListState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeListNotifier(repo);
});
