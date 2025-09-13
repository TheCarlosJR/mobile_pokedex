import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_evochain_model.dart';
import 'package:pokedex/data/repositories/poke_evochain_repo.dart';

/// Estado do detalhe da evolucao do Pokemon
class PokeEvoChainState {
  final PokeEvoChainModel? evoChain;
  final bool isLoading;
  final bool hasError;
  String? errorMsg;

  PokeEvoChainState({
    required this.evoChain,
    this.isLoading = false,
    this.hasError = false,
    this.errorMsg,
  });

  PokeEvoChainState copyWith({
    PokeEvoChainModel? evoChain,
    bool? isLoading,
    bool? hasError,
    String? errorMsg,
  }) {
    return PokeEvoChainState(
      evoChain: evoChain ?? this.evoChain,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// Provider do repositorio
final pokeRepoProvider = Provider((ref) => PokeEvoChainRepo());

/// ViewModel
class PokeEvoChainNotifier extends StateNotifier<PokeEvoChainState> {
  final PokeEvoChainRepo repository;

  PokeEvoChainNotifier(this.repository)
      : super(PokeEvoChainState(evoChain: null));

  Future<void> getEvoChain({required String url}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final evoChain = await repository.getEvoChain(url: url);

      state = state.copyWith(
        evoChain: evoChain,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }
}

/// Provider do estado da lista
final pokeEvoChainNotifierProvider =
StateNotifierProvider<PokeEvoChainNotifier, PokeEvoChainState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeEvoChainNotifier(repo);
});
