import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

class KansenViewModel implements QuizPromptAnswer {
  const KansenViewModel({
    required this.id,
    required this.name,
    required this.family,
    required this.rarity,
    required this.rarityLabel,
    required this.shipClass,
    required this.factionLabel,
    required this.portraitAsset,
    required this.skillAssets,
  });

  @override
  final String id;
  final String name;

  @override
  String get answerName => name;

  final KansenVariantFamily family;
  final KansenRarity rarity;
  final String rarityLabel;
  final String shipClass;
  final String factionLabel;
  final String portraitAsset;
  final List<String> skillAssets;
}
