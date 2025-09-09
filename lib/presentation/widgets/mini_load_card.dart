import 'package:flutter/material.dart';

import 'package:pokedex/core/constants/poke_enums.dart';
import 'package:pokedex/core/constants/poke_types.dart';

class MiniLoadCard extends StatefulWidget {
  const MiniLoadCard({super.key});

  @override
  State<MiniLoadCard> createState() => _MiniLoadCardState();
}

class _MiniLoadCardState extends State<MiniLoadCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence<Color?>(
      [
        for (int i = 0; i < (PokeTypes.values.length - 1); i++)
          TweenSequenceItem(
            tween: ColorTween(
              begin: PokeTypes.values.getColor(id: i),
              end: PokeTypes.values.getColor(id: i + 1),
            ),
            weight: 1,
          ),
      ],
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: PokeEnumConsts.colorNone.withOpacity(0.4),
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
      child: Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: _colorAnimation,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
