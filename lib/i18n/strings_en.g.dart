///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
	late final TranslationsTopBarEn topBar = TranslationsTopBarEn.internal(_root);
	late final TranslationsQuizEn quiz = TranslationsQuizEn.internal(_root);
	late final TranslationsKansendexEn kansendex = TranslationsKansendexEn.internal(_root);
	late final TranslationsDetailEn detail = TranslationsDetailEn.internal(_root);
	late final TranslationsCatalogEn catalog = TranslationsCatalogEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
	TranslationsAppEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Kansendex'
	String get title => 'Kansendex';
}

// Path: topBar
class TranslationsTopBarEn {
	TranslationsTopBarEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Appearance'
	String get appearanceTooltip => 'Appearance';

	/// en: 'Home'
	String get homeTooltip => 'Home';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: quiz
class TranslationsQuizEn {
	TranslationsQuizEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Discovery'
	String get modeDiscovery => 'Discovery';

	/// en: 'Random'
	String get modeRandom => 'Random';

	/// en: 'Dex'
	String get modeDex => 'Dex';

	/// en: 'Type exact kansen name'
	String get answerHint => 'Type exact kansen name';

	/// en: 'Submit Guess'
	String get submit => 'Submit Guess';

	/// en: 'Details'
	String get details => 'Details';

	/// en: 'Next prompt'
	String get nextPrompt => 'Next prompt';

	/// en: 'Unlocked in Kansendex'
	String get feedbackUnlocked => 'Unlocked in Kansendex';

	/// en: 'Exact name required, case ignored'
	String get feedbackIncorrect => 'Exact name required, case ignored';

	/// en: 'Identify locked kansens to complete the Dex.'
	String get discoveryModeHint => 'Identify locked kansens to complete the Dex.';

	/// en: 'Randomized kansen challenge.'
	String get randomModeHint => 'Randomized kansen challenge.';

	/// en: 'Discovery complete.'
	String get discoveryComplete => 'Discovery complete.';
}

// Path: kansendex
class TranslationsKansendexEn {
	TranslationsKansendexEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'All'
	String get segmentAll => 'All';

	/// en: 'Locked'
	String get segmentLocked => 'Locked';

	/// en: 'Unlocked'
	String get segmentUnlocked => 'Unlocked';

	/// en: 'No unlocked entries found'
	String get noUnlockedEntriesFound => 'No unlocked entries found';

	/// en: 'Identify to unlock'
	String get lockedCardLabel => 'Identify to unlock';

	/// en: 'Kansendex progress {percent} percent, {unlocked} of {total} unlocked'
	String semanticProgress({required Object percent, required Object unlocked, required Object total}) => 'Kansendex progress ${percent} percent, ${unlocked} of ${total} unlocked';

	/// en: '{name} added to Dex'
	String unlockToast({required Object name}) => '${name} added to Dex';
}

// Path: detail
class TranslationsDetailEn {
	TranslationsDetailEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Close'
	String get close => 'Close';
}

// Path: catalog
class TranslationsCatalogEn {
	TranslationsCatalogEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Could not load generated catalog {error}'
	String loadError({required Object error}) => 'Could not load generated catalog\n${error}';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Kansendex',
			'topBar.appearance' => 'Appearance',
			'topBar.appearanceTooltip' => 'Appearance',
			'topBar.homeTooltip' => 'Home',
			'topBar.themeSystem' => 'System',
			'topBar.themeLight' => 'Light',
			'topBar.themeDark' => 'Dark',
			'topBar.cancel' => 'Cancel',
			'quiz.modeDiscovery' => 'Discovery',
			'quiz.modeRandom' => 'Random',
			'quiz.modeDex' => 'Dex',
			'quiz.answerHint' => 'Type exact kansen name',
			'quiz.submit' => 'Submit Guess',
			'quiz.details' => 'Details',
			'quiz.nextPrompt' => 'Next prompt',
			'quiz.feedbackUnlocked' => 'Unlocked in Kansendex',
			'quiz.feedbackIncorrect' => 'Exact name required, case ignored',
			'quiz.discoveryModeHint' => 'Identify locked kansens to complete the Dex.',
			'quiz.randomModeHint' => 'Randomized kansen challenge.',
			'quiz.discoveryComplete' => 'Discovery complete.',
			'kansendex.search' => 'Search',
			'kansendex.segmentAll' => 'All',
			'kansendex.segmentLocked' => 'Locked',
			'kansendex.segmentUnlocked' => 'Unlocked',
			'kansendex.noUnlockedEntriesFound' => 'No unlocked entries found',
			'kansendex.lockedCardLabel' => 'Identify to unlock',
			'kansendex.semanticProgress' => ({required Object percent, required Object unlocked, required Object total}) => 'Kansendex progress ${percent} percent, ${unlocked} of ${total} unlocked',
			'kansendex.unlockToast' => ({required Object name}) => '${name} added to Dex',
			'detail.close' => 'Close',
			'catalog.loadError' => ({required Object error}) => 'Could not load generated catalog\n${error}',
			_ => null,
		};
	}
}
