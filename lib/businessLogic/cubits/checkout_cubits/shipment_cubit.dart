import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/checkout_blocs/shipment_state.dart';
import 'package:style_sphere/data/models/checkout/shipment_data.dart';
import 'package:style_sphere/data/repositories/checkout_repository/shipment_repository.dart';

class ShippingCubit extends Cubit<ShipmentState> {
  ShippingCubit({required ShippingRepository repository})
      : super(ShipmentLoadingState());
  final ShippingRepository shippingRepository = ShippingRepository();

  static ShippingCubit get(context) => BlocProvider.of(context);

  void getAllShipments() async {
    try {
      List<ShipmentModel> shipments =
          await shippingRepository.getAllShipments();
      emit(ShipmentLoadedState(shipments));
    } catch (e) {
      emit(ShipmentErrorState('Failed to fetch shipments: $e'));
    }
  }

  void deleteShipment(int shippingAddressID, String userID) async {
    try {
      bool deleted =
          await shippingRepository.deleteShipment(shippingAddressID, userID);
      if (deleted) {
        emit(ShipmentDeletedState());
        getUserShipments(userID);
      } else {
        emit(ShipmentErrorState('Failed to delete shipment'));
      }
    } catch (e) {
      emit(ShipmentErrorState('Failed to delete shipment: $e'));
    }
  }

  void addShipment(ShipmentModel shipment) async {
    try {
      bool added = await shippingRepository.addShipment(shipment);
      if (added) {
        emit(ShipmentAddedState());
        getUserShipments(shipment.userID!);
      } else {
        emit(ShipmentErrorState('Failed to add shipment'));
      }
    } catch (e) {
      emit(ShipmentErrorState('Failed to add shipment: $e'));
    }
  }

  void getShipment(int shippingAddressID, String userID) async {
    try {
      ShipmentModel shipment =
          await shippingRepository.getShipment(shippingAddressID, userID);
      emit(ShipmentLoadedState([shipment]));
    } catch (e) {
      emit(ShipmentErrorState('Failed to fetch shipment: $e'));
    }
  }

  void updateUserShipment(
      int shippingAddressID, String userID, ShipmentModel shipment) async {
    try {
      bool updated = await shippingRepository.updateShipment(
          shippingAddressID, userID, shipment);
      if (updated) {
        emit(ShipmentUpdatedState());
      } else {
        emit(ShipmentErrorState('Failed to update shipment'));
      }
    } catch (e) {
      emit(ShipmentErrorState('Failed to update shipment: $e'));
    }
  }

  void getUserShipments(String userID) async {
    try {
      List<ShipmentModel> shipments =
          await shippingRepository.getUserShipments(userID);
      emit(ShipmentLoadedState(shipments));
    } catch (e) {
      emit(ShipmentErrorState('Failed to fetch user shipments: $e'));
    }
  }
}
