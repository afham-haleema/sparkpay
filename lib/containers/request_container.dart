import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RequestContainer extends StatefulWidget {
  final String name, date;
  final double amount;
  final String description;
  final VoidCallback onYes;
  final String status;
  final VoidCallback onNo;
  final String currentUserId; // Pass the current user's ID
  final String receiverId; // The receiver's ID for this request

  const RequestContainer(
      {super.key,
      required this.amount,
      required this.date,
      required this.name,
      required this.description,
      required this.onYes,
      required this.onNo,
      required this.status,
      required this.currentUserId,
      required this.receiverId});

  @override
  State<RequestContainer> createState() => _RequestContainerState();
}

class _RequestContainerState extends State<RequestContainer> {
  bool isVisible = true;

  @override
  void initState() {
    isVisible = widget.status == 'pending';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isReceiver = widget.currentUserId == widget.receiverId;
    Color statusContainerColor;
    Color textColor;

    if (widget.status == 'approved') {
      statusContainerColor = const Color.fromARGB(255, 202, 239, 160);
      textColor = const Color.fromARGB(255, 20, 58, 21);
    } else if (widget.status == 'cancelled') {
      statusContainerColor = const Color.fromARGB(255, 245, 148, 148);
      textColor = const Color.fromARGB(255, 143, 28, 26);
    } else {
      statusContainerColor = const Color.fromARGB(255, 244, 234, 149);
      textColor = const Color.fromARGB(255, 237, 195, 9);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Container(
          width: MediaQuery.of(context).size.width * .90,
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.date),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.description),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'BHD ${widget.amount}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: statusContainerColor,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            width: 100,
                            height: 40,
                            child: Text(
                              widget.status,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                        isVisible && isReceiver
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = false;
                                      });
                                      widget.onNo();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Color.fromARGB(255, 23, 50, 97),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = false;
                                      });
                                      widget.onYes();
                                    },
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 23, 50, 97),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                ],
                              )
                            : SizedBox()
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
