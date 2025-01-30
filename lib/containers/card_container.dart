import 'package:flutter/material.dart';

class CardContainer extends StatefulWidget {
  final Map<String, dynamic> accountData;
  const CardContainer({
    super.key,
    required this.accountData,
  });

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: MediaQuery.of(context).size.width * .90,
        //height: 180,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 57, 96),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Platinum',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 206, 186, 186)),
                  ),
                  Spacer(),
                  Text(
                    widget.accountData['bankname'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(widget.accountData['balance'],
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                  Spacer(),
                  Text(
                    'VISA',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
