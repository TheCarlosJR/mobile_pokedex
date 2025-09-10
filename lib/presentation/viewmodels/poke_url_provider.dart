import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_url_model.dart';
import 'package:pokedex/data/repositories/poke_url_repo.dart';

/// Estado da lista de Pokemons com dados
class PokeListUrlState {
  final List<PokeUrlModel> pokemons;
  final bool isLoading;
  final bool hasError;
  String? errorMsg;

  PokeListUrlState({
    required this.pokemons,
    this.isLoading = false,
    this.hasError = false,
    this.errorMsg,
  });

  PokeListUrlState copyWith({
    List<PokeUrlModel>? pokemons,
    bool? isLoading,
    bool? hasError,
    String? errorMsg,
  }) {
    return PokeListUrlState(
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
class PokeListUrlNotifier extends StateNotifier<PokeListUrlState> {
  final PokeUrlRepo repository;

  PokeListUrlNotifier(this.repository)
      : super(PokeListUrlState(pokemons: []));

  Future<void> loadPokemons() async {
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
final pokeListUrlNotifierProvider =
StateNotifierProvider<PokeListUrlNotifier, PokeListUrlState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeListUrlNotifier(repo);
});
