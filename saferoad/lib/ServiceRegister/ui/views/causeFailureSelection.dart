import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/bloc/causeFailure/cause_failure_bloc.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/BillAppBar.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/customButton.dart';

class CauseOfFailureSelectionPage extends StatefulWidget {
  final Request requestData;

  CauseOfFailureSelectionPage({
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

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Lottie.asset(
                          "assets/selectOption.json",
                          fit: BoxFit.contain,
                          width: constraints.maxWidth * 0.5,
                          height: constraints.maxHeight * 0.3,
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
                      Wrap(
                        spacing: 16.0, // Espaciado horizontal entre elementos
                        runSpacing: 8.0, // Espaciado vertical entre filas
                        children: causes.map((cause) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCause = cause.id;
                              });
                            },
                            child: Container(
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
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: CustomElevatedButton(
                          label: 'Finalizar servicio',
                          onPressed: () {
                            if (selectedCause != null) {
                              final causeFailureBloc =
                                  BlocProvider.of<CauseFailureBloc>(context);
                              causeFailureBloc.saveSelectedOption(
                                  widget.requestData.id!, selectedCause!);
                            }
                          },
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
