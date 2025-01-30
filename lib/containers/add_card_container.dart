import 'package:flutter/material.dart';

class AddCardContainer extends StatefulWidget {
  const AddCardContainer({super.key});

  @override
  State<AddCardContainer> createState() => _AddCardContainerState();
}

class _AddCardContainerState extends State<AddCardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/add-card');
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .85,
        height: 180,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 240, 243),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color.fromARGB(255, 13, 53, 86), width: 1.5)),
        child: Center(
          child: Text(
            '+ Add card',
            style:
                TextStyle(fontSize: 24, color: Color.fromARGB(255, 13, 53, 86)),
          ),
        ),
      ),
    );
  }
}
