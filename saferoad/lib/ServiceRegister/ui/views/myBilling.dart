import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/bloc/myBilling/my_billing_bloc.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/billItemWidget.dart';
import 'package:saferoad/ServiceRegister/ui/widgets/customButton.dart';

class MyBilling extends StatefulWidget {
  final Request request;

  const MyBilling({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  _MyBillingState createState() => _MyBillingState();
}

class _MyBillingState extends State<MyBilling> {
  bool isRejected = false;
  @override
  void initState() {
    final myBillingBloc = BlocProvider.of<MyBillingBloc>(context);
    print("BUSCANDO SERVICIO AL INICIO");
    print(widget.request.service);
    if (widget.request.service != "") {
      myBillingBloc.getService(widget.request.service);
      isRejected = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBillingBloc, MyBillingState>(
        builder: (context, state) {
      final myBillingBloc = BlocProvider.of<MyBillingBloc>(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora de Cobro'),
        ),
        body: Column(
          children: [
            if (state.billItems.isEmpty ||
                (widget.request.service == "" && isRejected))
              _buildEmptyState(context),
            if (state.billItems.isNotEmpty)
              _buildBillItemsList(context, state, myBillingBloc),
            _buildAddItemForm(
                context, state, myBillingBloc, widget.request.id!),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                'assets/Billpage.json',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "No hay elementos aún",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillItemsList(
      BuildContext context, MyBillingState state, MyBillingBloc myBillingBloc) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.billItems.length,
        itemBuilder: (context, index) {
          return BillItemWidget(
              state: state, index: index, myBillingBloc: myBillingBloc);
        },
      ),
    );
  }

  Widget _buildAddItemForm(BuildContext context, MyBillingState state,
      MyBillingBloc myBillingBloc, String requestId) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: state.nameController,
              decoration: const InputDecoration(
                labelText: 'Concepto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
              onChanged: (value) {
                myBillingBloc.add(TextNameChangedEvent(state.nameController));
              },
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: state.valueController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                myBillingBloc.add(TextValueChangedEvent(state.valueController));
              },
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  label: 'Agregar Elemento',
                  onPressed: () {
                    myBillingBloc.addBillItem();
                    myBillingBloc.calculateTotalCost();
                  },
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16.0),
                CustomElevatedButton(
                  label: 'Enviar costo total',
                  onPressed: () {
                    if (state.total == 0) {
                      const snackBar = SnackBar(
                        content: Text(
                            'Por favor, Ingresa al menos el costo de tu viaje'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      myBillingBloc.saveService(requestId);

                      //Navigator.of(context).pop();
                    }
                  },
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              'Costo Total: \$${state.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
