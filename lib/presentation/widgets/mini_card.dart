import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/core/constants/text_styles.dart';
import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/constants/poke_types.dart';

import 'package:pokedex/data/models/poke_data_model.dart';

import 'package:pokedex/presentation/widgets/micro_type.dart';

class MiniCard extends StatelessWidget {
  final PokeDataModel pokemon;
  final Function()? onTap;

  const MiniCard({
    super.key,
    required this.pokemon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //obtem cor do tipo principal
    final mainColor = Color(pokemon.typeNames.isNotEmpty
        ? PokeTypes.values.findByNamePTBR(pokemon.typeNames[0])?.colorValue ?? PokeEnumConsts.colorNoneValue
        : PokeEnumConsts.colorNoneValue);

    //obtem cor do tipo principal com transparencia
    final mainHalfColor = mainColor.withOpacity(0.4);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: mainHalfColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                'lib/assets/container_bg.png',
                width: 400,
                repeat: ImageRepeat.repeat,
              ),
            ),
            Positioned(
              right: -5,
              bottom: -10,
              child: Image.asset(
                'lib/assets/pokeball-banner-maratuna-dark.png',
                colorBlendMode: BlendMode.lighten,
                width: 80,
              ),
            ),
            //animar onTap a partir daqui
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Text(
                          'ID',
                          style: TextStyles.miniCardID,
                        ),
                      ),
                      Text(
                        '#${Utils.formatPokeID(pokemon.id)}',
                        style: TextStyles.miniCardID,
                      ),
                      //const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {},
                        iconSize: 16,
                        icon: Icon(
                          pokemon.fav
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //esquerda ---------------------------------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  pokemon.name,
                                  style: TextStyles.miniCardName,
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.4,
                                  ),
                                  itemCount: pokemon.typeNames.length,
                                  itemBuilder: (context, index) {
                                    return MicroType(
                                      color: mainColor,
                                      typeName: pokemon.typeNames[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //direita ----------------------------------------------
                        pokemon.imageVectorUrl != null
                            ? SvgPicture.network(
                                width: 80,
                                fit: BoxFit.contain,
                                pokemon.imageVectorUrl!,
                              )
                            : Image.network(
                                width: 70,
                                fit: BoxFit.contain,
                                pokemon.imageUrl,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
