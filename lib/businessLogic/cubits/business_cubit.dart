import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_sphere/businessLogic/blocs/business_state.dart';
import 'package:style_sphere/data/models/business_data.dart';
import 'package:style_sphere/data/repositories/business_repository.dart';

class BusinessCubit extends Cubit<BusinessState> {
  BusinessCubit({required BusinessRepository repository})
      : super(BusinessLoadingState());
  final BusinessRepository _businessRepository = BusinessRepository();

  static BusinessCubit get(context) => BlocProvider.of(context);

  Future<void> fetchAllBusinesses() async {
    try {
      emit(BusinessLoadingState());
      final businesses = await _businessRepository.getAllBusinesses();
      emit(BusinessLoadedState(businesses));
    } catch (e) {
      emit(BusinessErrorState('Failed to load businesses'));
    }
  }

  Future<void> fetchBusiness(String id) async {
    try {
      emit(BusinessLoadingState());

      final business = await _businessRepository.getBusiness(id);
      if (business == null) {
        emit(BusinessLoadedState([]));
      } else {
        emit(BusinessLoadedState([business]));
      }
    } catch (e) {
      emit(BusinessErrorState('Failed to load business'));
    }
  }

  Future<void> createBusiness(BusinessModel business) async {
    try {
      emit(BusinessLoadingState());
      final message = await _businessRepository.createBusiness(business);
      emit(BusinessAddedState());
    } catch (e) {
      emit(BusinessErrorState('Failed to create business'));
    }
  }

  Future<void> updateBusiness(String id, BusinessModel business) async {
    try {
      emit(BusinessLoadingState());
      final message = await _businessRepository.updateBusiness(id, business);
      emit(BusinessUpdatedState());
    } catch (e) {
      emit(BusinessErrorState('Failed to update business'));
    }
  }

  Future<void> deleteBusiness(String id) async {
    try {
      emit(BusinessLoadingState());
      final message = await _businessRepository.deleteBusiness(id);
      emit(BusinessDeletedState());
    } catch (e) {
      emit(BusinessErrorState('Failed to delete business'));
    }
  }
}
