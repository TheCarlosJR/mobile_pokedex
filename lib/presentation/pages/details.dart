import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/core/constants/text_styles.dart';
import 'package:pokedex/core/constants/poke_types.dart';

import 'package:pokedex/data/models/poke_list_model.dart';

import 'package:pokedex/presentation/viewmodels/poke_specie_provider.dart';
import 'package:pokedex/presentation/viewmodels/poke_evochain_provider.dart';
import 'package:pokedex/presentation/widgets/detail_table.dart';

enum DetailsButton {
  details,
  stats,
  evolutions,
  moves,
}

class DetailsPage extends ConsumerStatefulWidget {
  const DetailsPage({
    super.key,
    required this.pokemon,
  });

  final PokeListModel pokemon;

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  final selectedButtonProvider =
      StateProvider<DetailsButton>((ref) => DetailsButton.details);

  /// Altera selecao pelo enum
  DetailsButton changeButtonSel(DetailsButton selDetailButton) {
    return ref.read(selectedButtonProvider.notifier).state = selDetailButton;
  }

  /// Obtem o mapa de dados de acordo com a selecao
  Map<String, String> getInfoMap(
      DetailsButton selDetailButton,
      Map<String, String>? about,
      Map<String, String>? evoChainList) {
    switch (selDetailButton) {
      case DetailsButton.stats:
        return widget.pokemon.stats;
      case DetailsButton.evolutions:
        return evoChainList ?? <String, String>{};
      case DetailsButton.moves:
        return widget.pokemon.moves;
      //case DetailsButton.details:
      default:
        return about ?? <String, String>{};
    }
  }

  @override
  void initState() {
    super.initState();

    //obtem dados da especie
    Future.microtask(() => ref
        .read(pokeSpecieNotifierProvider.notifier)
        .loadSpecie(id: widget.pokemon.id));
  }

  @override
  Widget build(BuildContext context) {
    //estado do specie pokemon
    final specieState = ref.watch(pokeSpecieNotifierProvider);
    //estado do evoChain pokemon
    final evoChainState = ref.watch(pokeEvoChainNotifierProvider);

    //se estado tem algum erro
    if (specieState.hasError) {
      return Center(
        child: Column(
          children: [
            const Text('Erro ao carregar API!'),
            ElevatedButton(
              child: const Text('Tentar novamente'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    //combina dois maps (ou apenas usa o primeiro)
    final about = {
      ...widget.pokemon.about,
      ...?specieState.specie?.details,
    };

    //obtem map de evolucao
    final evoChainList = evoChainState.evoChain?.evoList;

    //obtem cor do tipo principal
    final mainColor = Color(widget.pokemon.typeNames.isNotEmpty
        ? PokeTypes.values
                .findByNamePTBR(widget.pokemon.typeNames[0])
                ?.colorValue ??
            PokeEnumConsts.colorNoneValue
        : PokeEnumConsts.colorNoneValue);

    //cor variante da principal
    final Color halfMainColor = mainColor.withOpacity(0.5);

    //estado dos botoes ChoiceChip
    final selButtonState = ref.watch(selectedButtonProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Text(
              widget.pokemon.name,
              style: TextStyles.macroDetailName,
            ),
            const Expanded(
              child: Spacer(),
            ),
            Text(
              '#${Utils.formatPokeID(widget.pokemon.id)}',
              style: TextStyles.macroDetailID,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.pokemon.fav
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              color: Colors.black,
            ),
            onPressed: () {
              //widget.pokemon.fav = !widget.pokemon.fav;
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // cor de fundo ------------------------------------------------------
          Container(
            width: double.infinity,
            height: double.infinity,
            color: mainColor.withOpacity(0.65),
          ),
          // imagem de fundo ---------------------------------------------------
          Positioned(
            top: -20,
            right: -20,
            child: Image.asset(
              'lib/assets/pokeball-banner-maratuna-dark.png',
              colorBlendMode: BlendMode.lighten,
              width: 400,
            ),
          ),
          // tabela ------------------------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 260,
                    left: 15,
                    right: 15,
                  ),
                  padding: const EdgeInsets.only(
                    top: 70,
                    left: 30,
                    right: 30,
                    bottom: 20,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      opacity: 0.5,
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'lib/assets/container_bg.png',
                      ),
                    ),
                    border: Border(
                      top: BorderSide(width: 1.5),
                      right: BorderSide(width: 3),
                      left: BorderSide(width: 3),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                  ),
                  child: specieState.isLoading
                      ? const Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            //botoes de abas
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 0,
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ChoiceChip(
                                    selectedColor: mainColor,
                                    backgroundColor: halfMainColor,
                                    label: const Text('Sobre'),
                                    selected:
                                        selButtonState == DetailsButton.details,
                                    onSelected: (_) =>
                                        changeButtonSel(DetailsButton.details),
                                  ),
                                  ChoiceChip(
                                    selectedColor: mainColor,
                                    backgroundColor: halfMainColor,
                                    label: const Text('Dados'),
                                    selected:
                                        selButtonState == DetailsButton.stats,
                                    onSelected: (_) =>
                                        changeButtonSel(DetailsButton.stats),
                                  ),
                                  ChoiceChip(
                                    selectedColor: mainColor,
                                    backgroundColor: halfMainColor,
                                    label: const Text('Evolução'),
                                    selected: selButtonState ==
                                        DetailsButton.evolutions,
                                    onSelected: (_) => changeButtonSel(
                                        DetailsButton.evolutions),
                                  ),
                                  ChoiceChip(
                                    selectedColor: mainColor,
                                    backgroundColor: halfMainColor,
                                    label: const Text('Golpes'),
                                    selected:
                                        selButtonState == DetailsButton.moves,
                                    onSelected: (_) =>
                                        changeButtonSel(DetailsButton.moves),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            //tabela real com as informacoes selecionadas
                            Expanded(
                              child: DetailTable(
                                color: mainColor,
                                data: getInfoMap(
                                  selButtonState,
                                  about,
                                  evoChainList,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          // sombreamento sprite -----------------------------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 263,
                  left: 70,
                  right: 70,
                ),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    //color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(280)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black26,
                        blurStyle: BlurStyle.inner,
                      ),
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.black26,
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // sprite ------------------------------------------------------------
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: widget.pokemon.imageVectorUrl != null
                    ? SvgPicture.network(
                        //width: double.infinity,
                        height: 280,
                        fit: BoxFit.contain,
                        widget.pokemon.imageVectorUrl!,
                      )
                    : Image.network(
                        //width: double.infinity,
                        height: 280,
                        fit: BoxFit.contain,
                        widget.pokemon.imageUrl,
                      ),
              ),
            ],
          ),
          /*
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.pokemon.imageVectorUrl != null
                          ? SvgPicture.network(
                              //width: double.infinity,
                              //fit: BoxFit.contain,
                              widget.pokemon.imageVectorUrl!,
                            )
                          : Image.network(
                              width: double.infinity,
                              fit: BoxFit.contain,
                              widget.pokemon.imageUrl,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
