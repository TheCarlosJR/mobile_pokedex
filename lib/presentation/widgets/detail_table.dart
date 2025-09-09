import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pokedex/core/constants/text_styles.dart';

/// Provider que armazena a query busca do TextField
final pokeSearchProvider = StateProvider<String>((ref) => '');

/// Widget base para exibir a tabela de detalhes
class DetailTable extends ConsumerStatefulWidget {
  const DetailTable({
    super.key,
    required this.color,
    required this.data,
  });

  final Color color;
  final Map<String, String> data;

  @override
  ConsumerState<DetailTable> createState() => _DetailTableState();
}

class _DetailTableState extends ConsumerState<DetailTable> {
  @override
  Widget build(BuildContext context) {
    //observa a query de busca do TextField
    final searchQuery = ref.watch(pokeSearchProvider).toLowerCase();

    //filtra o Map pelo texto digitado (otimizado)
    final filteredMapRef = searchQuery.isEmpty
        ? widget.data
        : widget.data.entries
            .where((entry) =>
                entry.key.toLowerCase().contains(searchQuery) ||
                entry.value.toLowerCase().contains(searchQuery))
            .fold<Map<String, String>>({}, (map, entry) {
            map[entry.key] = entry.value;
            return map;
          });

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Procure um valor',
                  suffixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.color,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  ref.read(pokeSearchProvider.notifier).state = value;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: filteredMapRef.length,
            itemBuilder: (context, index) {
              final key = filteredMapRef.keys.elementAt(index);
              final value = filteredMapRef[key] ?? '';

              return Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$key:',
                      style: TextStyles.tableCellDetails,
                    ),
                    //const SizedBox(width: 30),
                    Text(
                      value,
                      style: TextStyles.tableCellDetails,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
