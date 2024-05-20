import 'package:style_sphere/data/models/business_data.dart';

abstract class BusinessState {}

class BusinessLoadingState extends BusinessState {}

class BusinessLoadedState extends BusinessState {
  final List<BusinessModel> businesses;

  BusinessLoadedState(this.businesses);
}

class BusinessAddedState extends BusinessState {}

class BusinessDeletedState extends BusinessState {}

class BusinessUpdatedState extends BusinessState {}

class BusinessErrorState extends BusinessState {
  final String errorMessage;

  BusinessErrorState(this.errorMessage);
}
