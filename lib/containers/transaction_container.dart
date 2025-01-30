import 'package:flutter/material.dart';

class TransactionContainer extends StatefulWidget {
  final String name, date;
  final String amount;
  const TransactionContainer(
      {super.key,
      required this.amount,
      required this.date,
      required this.name});

  @override
  State<TransactionContainer> createState() => _TransactionContainerState();
}

class _TransactionContainerState extends State<TransactionContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .90,
        height: 70,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1.2)
            ],
            color: const Color.fromARGB(255, 244, 240, 240),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(widget.date)
                ],
              ),
              Spacer(),
              Text(
                '${widget.amount}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
