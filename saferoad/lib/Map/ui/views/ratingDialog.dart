import 'package:flutter/material.dart';

import '../../../Home/ui/views/userpage.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({
    Key? key,
    required this.userType,
  }) : super(key: key);

  final String? userType;
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Calificar el servicio',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = i.toDouble();
                      });
                    },
                    child: Icon(
                      Icons.star,
                      color: i <= rating ? Colors.orange : Colors.grey,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserPage(),
                  ),
                ); // Devuelve la calificación al widget anterior
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
