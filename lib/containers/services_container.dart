import 'package:flutter/material.dart';

class ServicesContainer extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const ServicesContainer({super.key, required this.text, required this.onTap});

  @override
  State<ServicesContainer> createState() => _ServicesContainerState();
}

class _ServicesContainerState extends State<ServicesContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(216, 244, 239, 239),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(width: 1.5, color: Color.fromARGB(255, 23, 50, 97))),
      width: MediaQuery.of(context).size.width * .40,
      height: 70,
      alignment: Alignment.center,
      child: TextButton(
          onPressed: widget.onTap,
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
    );
  }
}
