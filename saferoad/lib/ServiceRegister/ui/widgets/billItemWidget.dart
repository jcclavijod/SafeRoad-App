import 'package:flutter/material.dart';
import 'package:saferoad/ServiceRegister/bloc/myBilling/my_billing_bloc.dart';

class BillItemWidget extends StatelessWidget {
  final MyBillingState state;
  final int index;
  final MyBillingBloc myBillingBloc;

  BillItemWidget({
    required this.state,
    required this.index,
    required this.myBillingBloc,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameEditingController = state.isEditing
        ? state.editNameController
        : TextEditingController(text: state.billItems[index].name);
    final TextEditingController valueEditingController = state.isEditing
        ? state.editValueController
        : TextEditingController(
            text: state.billItems[index].value.toStringAsFixed(0));
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: state.isEditing
            ? TextFormField(
                controller: nameEditingController,
                decoration: const InputDecoration(
                  labelText: 'Concepto',
                  border: InputBorder.none,
                ),
              )
            : Text(
                state.billItems[index].name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            state.isEditing
                ? TextFormField(
                    controller: valueEditingController,
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                  )
                : Text(
                    'Valor: \$${state.billItems[index].value.toStringAsFixed(0)}',
                  ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!state.isEditing)
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () {
                  myBillingBloc.startEditing(index);
                },
              ),
            if (!state.isEditing)
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  myBillingBloc.deleteBillItem(index);
                },
              ),
            if (state.isEditing)
              IconButton(
                icon: const Icon(Icons.check),
                color: Colors.green,
                onPressed: () {
                  myBillingBloc.saveChanges(index);
                },
              ),
            if (state.isEditing)
              IconButton(
                icon: const Icon(Icons.cancel),
                color: Colors.red,
                onPressed: () {
                  myBillingBloc.cancelEditing();
                },
              ),
          ],
        ),
      ),
    );
  }
}
