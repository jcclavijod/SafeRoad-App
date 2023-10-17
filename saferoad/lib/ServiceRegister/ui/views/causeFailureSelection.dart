import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/bloc/causeFailure/cause_failure_bloc.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/BillAppBar.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/customButton.dart';

class CauseOfFailureSelectionPage extends StatefulWidget {
  final Request requestData;

  const CauseOfFailureSelectionPage({super.key, 
    required this.requestData,
  });

  @override
  _CauseOfFailureSelectionPageState createState() =>
      _CauseOfFailureSelectionPageState();
}

class _CauseOfFailureSelectionPageState
    extends State<CauseOfFailureSelectionPage> {
  String? selectedCause;

  @override
  void initState() {
    final causeFailureBloc = BlocProvider.of<CauseFailureBloc>(context);
    causeFailureBloc.saveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BillAppBar(text: "Causas de la Falla mecánica"),
      ),
      body: BlocBuilder<CauseFailureBloc, CauseFailureState>(
        builder: (context, state) {
          final causes = state.causeOptions;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Lottie.asset(
                    "assets/selectOption.json",
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Selecciona la causa principal de la falla:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: causes.length,
                      itemBuilder: (context, index) {
                        final cause = causes[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCause = cause.id;
                                });
                              },
                              child: Container(
                                key: ValueKey<String>(cause.id),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: selectedCause == cause.id
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                    color: selectedCause == cause.id
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cause.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: selectedCause == cause.id
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    if (selectedCause == cause.id)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 8), // Espacio entre elementos
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (selectedCause != null) {
              final causeFailureBloc =
                  BlocProvider.of<CauseFailureBloc>(context);
              causeFailureBloc.saveSelectedOption(
                widget.requestData.id!,
                selectedCause!,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Finalizar servicio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
