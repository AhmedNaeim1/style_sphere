import 'package:style_sphere/data/models/checkout/shipment_data.dart';

abstract class ShipmentState {}

class ShipmentLoadingState extends ShipmentState {}

class ShipmentLoadedState extends ShipmentState {
  final List<ShipmentModel> shipments;

  ShipmentLoadedState(this.shipments);
}

class ShipmentAddedState extends ShipmentState {}

class ShipmentDeletedState extends ShipmentState {}

class ShipmentUpdatedState extends ShipmentState {}

class ShipmentErrorState extends ShipmentState {
  final String errorMessage;

  ShipmentErrorState(this.errorMessage);
}
