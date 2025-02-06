import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percent;

  const ChartBar(
      {super.key,
      required this.label,
      required this.value,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          SizedBox(
            height: boxConstraints.maxHeight * .15,
            child: FittedBox(
              child: Text(value.toStringAsFixed(2)),
            ),
          ),
          SizedBox(
            height: boxConstraints.maxHeight * .05,
          ),
          SizedBox(
            height: boxConstraints.maxHeight * .6,
            width: 10,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5)),
                ),
                AnimatedFractionallySizedBox(
                  heightFactor: percent,
                  duration: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: boxConstraints.maxHeight * .05,
          ),
          SizedBox(
            height: boxConstraints.maxHeight * .15,
            child: FittedBox(
              child: Text(label),
            ),
          )
        ],
      );
    });
  }
}
