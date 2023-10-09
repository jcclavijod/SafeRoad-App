import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/bloc/myBilling/my_billing_bloc.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/BillAppBar.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/customButton.dart';

class RequestDetailsView extends StatelessWidget {
  final Request requestData; // Datos de la solicitud

  RequestDetailsView({
    required this.requestData,
  });

  @override
  Widget build(BuildContext context) {
    final myBillingBloc = BlocProvider.of<MyBillingBloc>(context);
    return BlocBuilder<MyBillingBloc, MyBillingState>(
      builder: (context, state) {
        print("LILILILILILILILILILILI");
        print(requestData.id);
        print(requestData.service);
        myBillingBloc.getService(requestData.service);

        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: BillAppBar(text: "Factura del servicio"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Detalles de la Solicitud'),
                      _buildTable([
                        _buildTableRow('Dirección:', requestData.userAddress),
                      ]),
                      _buildTitle('Detalles del Servicio'),
                      _buildTable([
                        _buildTableRow('Total a Cobrar:',
                            '\$${state.service.totalCost.toStringAsFixed(0)}'),
                        _buildTableRow(
                            'Cantidad de labores realizadas:',
                            state.service.worksPerformed.length
                                .toStringAsFixed(0)),
                      ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('Labores Realizadas'),
                          SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.3, // Ajusta el factor según sea necesario
                            child: ListView(
                              shrinkWrap: true,
                              children: state.billItems.map((workPerformed) {
                                return _buildTable([
                                  _buildTableRow('Nombre:', workPerformed.name),
                                  _buildTableRow(
                                      'Costo:', '\$${workPerformed.value}'),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*CustomElevatedButton(
                      label: 'Rechazar',
                      onPressed: () {},
                      color: Colors.red,
                    ),*/
                    CustomElevatedButton(
                      label: 'Aceptar',
                      onPressed: () {
                        myBillingBloc.updateStatus(requestData.id!);
                      },
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTable(List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: rows),
    );
  }

  Widget _buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
