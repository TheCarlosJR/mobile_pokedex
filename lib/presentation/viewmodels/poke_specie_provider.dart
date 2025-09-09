import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/data/models/poke_specie_model.dart';
import 'package:pokedex/data/repositories/poke_specie_repo.dart';
import 'package:pokedex/presentation/viewmodels/poke_evochain_provider.dart';

/// Estado do detalhe do Pokemon
class PokeSpecieState {
  final PokeSpecieModel? specie;
  final bool isLoading;
  final bool hasError;
  String? errorMsg;

  PokeSpecieState({
    required this.specie,
    this.isLoading = false,
    this.hasError = false,
    this.errorMsg,
  });

  PokeSpecieState copyWith({
    PokeSpecieModel? specie,
    bool? isLoading,
    bool? hasError,
    String? errorMsg,
  }) {
    return PokeSpecieState(
      specie: specie ?? this.specie,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}

/// Provider do repositorio
final pokeRepoProvider = Provider((ref) => PokeSpecieRepo());

/// ViewModel
class PokeSpecieNotifier extends StateNotifier<PokeSpecieState> {
  final Ref refEvoChain;
  final PokeSpecieRepo repository;

  PokeSpecieNotifier(this.refEvoChain, this.repository)
      : super(PokeSpecieState(specie: null));

  Future<void> loadSpecie({required int id}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final specie = await repository.getSpecie(id: id);

      state = state.copyWith(
        specie: specie,
        isLoading: false,
      );

      //encadeamento - carrega a evolucao baseado na specie
      await refEvoChain
          .read(pokeEvoChainNotifierProvider.notifier)
          .loadEvoChain(url: specie.evoChainUrl);
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMsg: e.toString());
    }
  }
}

/// Provider do estado da lista
final pokeSpecieNotifierProvider =
StateNotifierProvider<PokeSpecieNotifier, PokeSpecieState>((ref) {
  final repo = ref.watch(pokeRepoProvider);
  return PokeSpecieNotifier(ref, repo);
});
