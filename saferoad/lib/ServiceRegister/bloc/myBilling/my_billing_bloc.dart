import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/ServiceRegister/Repository/serviceRepository.dart';
import 'package:saferoad/ServiceRegister/model/billItem.dart';
import 'package:saferoad/ServiceRegister/model/service.dart';

part 'my_billing_event.dart';
part 'my_billing_state.dart';

class MyBillingBloc extends Bloc<MyBillingEvent, MyBillingState> {
  ServiceRepository serviceRepository = ServiceRepository(
      user: FirebaseAuth.instance.currentUser!,
      firestore: FirebaseFirestore.instance);

  MyBillingBloc()
      : super(MyBillingState(
          nameController: TextEditingController(),
          valueController: TextEditingController(),
          editNameController: TextEditingController(),
          editValueController: TextEditingController(),
        )) {
    on<EditingIndexLoaded>((event, emit) =>
        emit(state.copyWith(editingIndex: event.editingIndex)));

    on<AddTotal>((event, emit) => emit(state.copyWith(total: event.total)));

    on<TextNameChangedEvent>((event, emit) => emit(state.copyWith(
          nameController: event.nameController,
        )));

    on<TextValueChangedEvent>((event, emit) =>
        emit(state.copyWith(valueController: event.valueController)));

    on<TextEditChangedEvent>((event, emit) => emit(state.copyWith(
        nameController: event.editNameController,
        valueController: event.editValueController)));

    on<AddBillItem>(
        (event, emit) => emit(state.copyWith(billItems: event.billItems)));

    on<UpdateIsEditing>(
        (event, emit) => emit(state.copyWith(isEditing: event.isEditing)));

    on<UpdateServiceId>(
        (event, emit) => emit(state.copyWith(serviceId: event.serviceId)));

    on<AddService>(
        (event, emit) => emit(state.copyWith(service: event.service)));
  }

  void updateBillItems(List<BillItem> updatedBillItems) {
    final newState = state.copyWith(billItems: updatedBillItems);
    emit(newState);
  }

  void addBillItem() {
    final name = state.nameController.text;
    final value = double.tryParse(state.valueController.text) ?? 0.0;
    if (name.isNotEmpty && value > 0) {
      final newBillItem = BillItem(name: name, value: value);
      final List<BillItem> updatedBillItems = List.from(state.billItems)
        ..add(newBillItem);
      updateBillItems(updatedBillItems);
      state.nameController.clear();
      state.valueController.clear();
    }
  }

  void deleteBillItem(int index) {
    final updatedBillItems = List<BillItem>.from(state.billItems);
    updatedBillItems.removeAt(index);
    emit(state.copyWith(billItems: updatedBillItems));
    calculateTotalCost();
  }

  void startEditing(int index) {
    final item = state.billItems[index];
    state.editNameController.text = item.name;
    state.editValueController.text = item.value.toString();
    add(const UpdateIsEditing(true));
    add(EditingIndexLoaded(index));
  }

  void saveChanges(int index) {
    final newName = state.editNameController.text;
    final newValue = double.tryParse(state.editValueController.text) ?? 0.0;
    if (newName.isNotEmpty && newValue > 0) {
      state.billItems[index] = BillItem(name: newName, value: newValue);
      add(const EditingIndexLoaded(null));
      add(const UpdateIsEditing(false));
      calculateTotalCost();
      state.editNameController.clear();
      state.editValueController.clear();
    }
  }

  void cancelEditing() {
    emit(state.copyWith(editingIndex: null));
    add(const UpdateIsEditing(false));
    state.editNameController.clear();
    state.editValueController.clear();
  }

  void calculateTotalCost() {
    double total = 0.0;
    for (var item in state.billItems) {
      total += item.value;
    }
    add(AddTotal(total));
  }

  void clean() async {
    add(const AddBillItem([]));
    add(const AddTotal(0));
  }

  void saveService(String request) async {
    List<String> list =
        await serviceRepository.saveWorkPerformed(state.billItems);
    String id =
        await serviceRepository.finalizeService(request, state.total, list);
    add(UpdateServiceId(id));
    clean();
  }

  void getService(String requestId,) async {
    print("LISTA QUE DEBERIA ESTAR VACIA");
    print(state.billItems.length);
    Service? service = await serviceRepository.getServiceData(requestId);
    print(service);
    List<BillItem> updatedBillItems =
        await serviceRepository.getBillItems(service!.worksPerformed);
    add(AddService(service));
    add(AddTotal(service.totalCost));
    updateBillItems(updatedBillItems);
    print("LISTA CON LOS ITEMS ENVIADOS");
    print(updatedBillItems.length);
  }

  void updateStatus(String request, String status) {
    serviceRepository.updateStatus(request, status);
  }
}
