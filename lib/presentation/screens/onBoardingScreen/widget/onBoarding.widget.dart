import 'package:flutter/material.dart';
import 'package:rpe_c/core/models/onBoarding.model.dart';
import 'package:rpe_c/presentation/widgets/custom.text.style.dart';
import 'package:rpe_c/presentation/widgets/dimensions.widget.dart';

class PageCard extends StatelessWidget {
  final OnBoardingModel card;

  const PageCard({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
        children: [
          hSizedBox4,
          _buildPicture(context),
          hSizedBox3,
          _buildText(context),
        ],
      ),
    );
  }

  Widget _buildPicture(
    BuildContext context, {
    double size = 380,
  }) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(
        top: 140,
      ),
      child: Image.asset(card.image!),
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      card.title!,
      textAlign: TextAlign.center,
      style: CustomTextWidget.bodyText1(
        color: card.textColor,
      ),
    );
  }
}
