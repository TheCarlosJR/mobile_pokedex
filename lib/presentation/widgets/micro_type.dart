import 'package:flutter/material.dart';

import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/constants/poke_types.dart';
import 'package:pokedex/core/constants/text_styles.dart';

class MicroType extends StatelessWidget {
  const MicroType({
    super.key,
    required this.color,
    required this.typeName,
  });

  final Color color;
  final String typeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          typeName,
          style: TextStyles.microType,
        ),
      ),
    );
  }
}
