import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_art.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_row.dart';

class KansenDetailScreen extends StatefulWidget {
  const KansenDetailScreen({super.key, required this.kansen});

  final KansenViewModel kansen;

  @override
  State<KansenDetailScreen> createState() => _KansenDetailScreenState();
}

class _KansenDetailScreenState extends State<KansenDetailScreen> {
  Offset _pointer = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final center = Offset(size.width / 2, size.height / 2);
    final delta =
        (_pointer == Offset.zero ? Offset.zero : _pointer - center) / 80;
    final tokens = KansenThemeTokens.of(context);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) =>
              setState(() => _pointer = details.localPosition),
          child: Stack(
            children: [
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(delta.dx, delta.dy),
                  child: Hero(
                    tag: widget.kansen.name,
                    child: KansenArt(asset: widget.kansen.portraitAsset),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(CupertinoIcons.xmark),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.detailSurface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: tokens.hairline.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.kansen.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        KansenHintRow(kansen: widget.kansen),
                        const SizedBox(height: 12),
                        Row(
                          children: widget.kansen.skillAssets.map((asset) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  asset,
                                  width: 44,
                                  height: 44,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
