import 'package:flutter/material.dart';

class HugeButtonWithIcon extends StatefulWidget {
  final String title, description;
  final Widget image;
  final bool startsSelected;
  final Function() onClick;

  const HugeButtonWithIcon({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.startsSelected = false,
    required this.onClick,
  });

  @override
  State<HugeButtonWithIcon> createState() => _HugeButtonWithIconState();
}

class _HugeButtonWithIconState extends State<HugeButtonWithIcon> {
  bool selected = true;

  bool get getSelected => selected;

  set setSelected(bool selected) => this.selected = selected;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Colors.transparent,
      onPressed: widget.onClick,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Color(0xff1970B7) : Colors.grey,
            width: 2,
          ),
        ),
        child: SizedBox(
          width: 300 + 32,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  widget.image,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.description,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
