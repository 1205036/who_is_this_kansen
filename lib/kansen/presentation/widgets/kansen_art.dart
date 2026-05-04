import 'package:flutter/material.dart';

class KansenArt extends StatelessWidget {
  const KansenArt({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}

class KansenSilhouetteImage extends StatelessWidget {
  const KansenSilhouetteImage({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff030608), Color(0xff101a23)],
        ).createShader(bounds);
      },
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
