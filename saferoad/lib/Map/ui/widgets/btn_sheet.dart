import 'package:flutter/material.dart';

import '../../../Auth/model/user_model.dart';
import '../../../Chat/ui/widgets/buttonChat.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    Key? key,
    required this.receiver,
    required this.authenticatedUser,
  }) : super(key: key);

  final UserModel? authenticatedUser;
  final UserModel? receiver;

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(220, 230, 240, 0.9),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isExpanded ? 0.0 : 40.0),
            ),
            boxShadow: [
              BoxShadow(
                color: isExpanded
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.3,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 8.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.message),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child:  Text(
                                          "Taller ${widget.authenticatedUser?.local ?? 'Local'}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(widget
                                            .authenticatedUser!.profilePic),
                                        radius:
                                            35, // Ajusta el tamaño de la imagen aquí
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 23.0),
                            Container(
                              height: 2,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            const SizedBox(height: 23.0),
                            const Text(
                              "Chat cliente",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ChatBody(
                              receiver: widget.receiver,
                              authenticatedUser: widget.authenticatedUser,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.attach_money),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.label,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'Costo del servicio',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              '\$9.000',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.close),
                        Column(
                          children: [
                            const Text(
                              'Cancelar servicio',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Dismissible(
                              key: const Key('cancel'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(-4, 0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Acción para cancelar el servicio
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: const Text('Cancelar servicio'),
                                  ),
                                ],
                              ),
                              onDismissed: (direction) {
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWidgetContainer(Widget leading, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
