part of 'my_billing_bloc.dart';

class MyBillingState extends Equatable {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final TextEditingController editNameController;
  final TextEditingController editValueController;
  List<BillItem> billItems;
  final int editingIndex;
  final double total;
  final bool isEditing;
  final String serviceId;
  final Service service;

  MyBillingState(
      {this.billItems = const [],
      required this.nameController,
      required this.valueController,
      required this.editNameController,
      required this.editValueController,
      this.editingIndex = -1,
      this.total = 0.0,
      this.isEditing = false,
      this.serviceId = "",
      this.service = const Service(customerAcceptance: '', date: '', totalCost: 0.0, worksPerformed: [])});

  MyBillingState copyWith(
          {TextEditingController? nameController,
          TextEditingController? valueController,
          TextEditingController? editNameController,
          TextEditingController? editValueController,
          List<BillItem>? billItems,
          int? editingIndex,
          double? total,
          bool? isEditing,
          String? serviceId,
          Service? service}) =>
      MyBillingState(
        nameController: nameController ?? this.nameController,
        valueController: valueController ?? this.valueController,
        editNameController: editNameController ?? this.editNameController,
        editValueController: editValueController ?? this.editValueController,
        billItems: billItems ?? this.billItems,
        editingIndex: editingIndex ?? this.editingIndex,
        total: total ?? this.total,
        isEditing: isEditing ?? this.isEditing,
        serviceId: serviceId ?? this.serviceId,
        service: service ?? this.service,
      );

  @override
  List<Object> get props => [
        nameController,
        valueController,
        editNameController,
        billItems,
        total,
        editingIndex,
        isEditing,
        serviceId,
        service
      ];
}
