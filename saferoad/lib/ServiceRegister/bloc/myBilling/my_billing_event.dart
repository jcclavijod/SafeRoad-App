part of 'my_billing_bloc.dart';

class MyBillingEvent extends Equatable {
  const MyBillingEvent();

  @override
  List<Object> get props => [];
}

class EditingIndexLoaded extends MyBillingEvent {
  final int? editingIndex;
  const EditingIndexLoaded(this.editingIndex);
}

class AddTotal extends MyBillingEvent {
  final double total;
  const AddTotal(this.total);
}

class TextNameChangedEvent extends MyBillingEvent {
  final TextEditingController nameController;
  const TextNameChangedEvent(this.nameController);
}

class TextValueChangedEvent extends MyBillingEvent {
  final TextEditingController valueController;
  const TextValueChangedEvent(this.valueController);
}

class TextEditChangedEvent extends MyBillingEvent {
  final TextEditingController editNameController;
  final TextEditingController editValueController;
  const TextEditChangedEvent(this.editNameController, this.editValueController);
}

class AddBillItem extends MyBillingEvent {
  final List<BillItem> billItems;
  const AddBillItem(this.billItems);
}

class UpdateIsEditing extends MyBillingEvent {
  final bool isEditing;
  const UpdateIsEditing(this.isEditing);
}

class UpdateServiceId extends MyBillingEvent {
  final String serviceId;
  const UpdateServiceId(this.serviceId);
}

class AddService extends MyBillingEvent {
  final Service service;
  const AddService(this.service);
}

