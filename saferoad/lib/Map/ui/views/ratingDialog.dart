import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../Home/ui/views/userpage.dart';
import '../../bloc/qualification/qualification_bloc.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({
    Key? key,
    required this.requestId,
    required this.receiverUid,
    required this.mechanicPic,
    required this.mechanicLocal,
  }) : super(key: key);

  final String? requestId;
  final String? receiverUid;
  final String? mechanicPic;
  final String? mechanicLocal;

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  @override
  void initState() {
    super.initState();
  }

  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QualificationBloc, QualificationState>(
      builder: (context, state) {
        final ratingBloc =
            BlocProvider.of<QualificationBloc>(context); // Obtener el bloc
        /*
        ratingBloc.getDocuments(
            widget.receiverUid!, state.mechanicPic, state.mechanicLocal);
            */
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título informativo en la parte superior
              Container(
                color: Colors.orange, // Color de fondo
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: const Center(
                  child: Text(
                    'Solicitud Finalizada con Éxito',
                    style: TextStyle(
                      color: Colors.white, // Color del texto
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Contenido del diálogo
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(widget.mechanicPic!),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Calificar al mecánico',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.mechanicLocal!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        ratingBloc.getDocuments(widget.receiverUid!,
                            widget.mechanicPic!, widget.mechanicLocal!);
                        ratingBloc.updateState(rating);
                        ratingBloc.setData();
                        //Navigator.of(context).pop(); // Cierra el diálogo
                        Navigator.of(context).pushReplacementNamed(
                            '/'); // Navega a la página de usuario
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // Color de fondo del botón
                        onPrimary: Colors.white, // Color del texto del botón
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12), // Padding del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        'Enviar Calificación',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Tu lógica para omitir la calificación aquí
                        Navigator.of(context).pop(); // Cierra el diálogo
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.grey, // Color del texto
                      ),
                      child: const Text(
                        'Omitir',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
