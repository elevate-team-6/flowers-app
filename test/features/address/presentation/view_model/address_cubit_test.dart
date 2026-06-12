import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_cities_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_placemark_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_current_location_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/update_address_use_case.dart';
import 'package:flowers_app/features/address/domain/utils/address_matcher.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_cubit_test.mocks.dart';

@GenerateMocks([
  GetAddressesUseCase,
  AddAddressUseCase,
  UpdateAddressUseCase,
  DeleteAddressUseCase,
  GetGovernoratesUseCase,
  GetCitiesUseCase,
  GetPlacemarkUseCase,
  GetCurrentLocationUseCase,
  AddressMatcher,
])
void main() {
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockAddAddressUseCase mockAddAddressUseCase;
  late MockUpdateAddressUseCase mockUpdateAddressUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late MockGetGovernoratesUseCase mockGetGovernoratesUseCase;
  late MockGetCitiesUseCase mockGetCitiesUseCase;
  late MockGetPlacemarkUseCase mockGetPlacemarkUseCase;
  late MockGetCurrentLocationUseCase mockGetCurrentLocationUseCase;
  late MockAddressMatcher mockAddressMatcher;

  const tAddress = AddressEntity(
    id: '1',
    recipientName: 'John Doe',
    phoneNumber: '0123456789',
    street: 'Street 1',
    city: 'Cairo',
    area: 'Maadi',
    latitude: '30.0444',
    longitude: '31.2357',
  );

  const tGov = GovernorateEntity(id: '1', nameAr: 'القاهرة', nameEn: 'Cairo');
  const tCity = CityEntity(
    id: '1',
    governorateId: '1',
    nameAr: 'المعادي',
    nameEn: 'Maadi',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>([tAddress]),
    );
    provideDummy<BaseResponse<List<GovernorateEntity>>>(
      SuccessBaseResponse<List<GovernorateEntity>>([tGov]),
    );
    provideDummy<BaseResponse<List<CityEntity>>>(
      SuccessBaseResponse<List<CityEntity>>([tCity]),
    );
  });

  setUp(() {
    mockGetAddressesUseCase = MockGetAddressesUseCase();
    mockAddAddressUseCase = MockAddAddressUseCase();
    mockUpdateAddressUseCase = MockUpdateAddressUseCase();
    mockDeleteAddressUseCase = MockDeleteAddressUseCase();
    mockGetGovernoratesUseCase = MockGetGovernoratesUseCase();
    mockGetCitiesUseCase = MockGetCitiesUseCase();
    mockGetPlacemarkUseCase = MockGetPlacemarkUseCase();
    mockGetCurrentLocationUseCase = MockGetCurrentLocationUseCase();
    mockAddressMatcher = MockAddressMatcher();
  });

  AddressCubit buildCubit() => AddressCubit(
    mockGetAddressesUseCase,
    mockAddAddressUseCase,
    mockUpdateAddressUseCase,
    mockDeleteAddressUseCase,
    mockGetGovernoratesUseCase,
    mockGetCitiesUseCase,
    mockGetPlacemarkUseCase,
    mockGetCurrentLocationUseCase,
    mockAddressMatcher,
  );

  group('Address Cubit Test Group', () {
    group('getAddresses', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [loading, success] when getAddresses succeeds',
        setUp: () {
          when(mockGetAddressesUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([tAddress]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const GetAddressesEvent()),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.addressesState.isLoading,
            'isLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.addressesState.isLoading, 'isLoading', false)
              .having((s) => s.addressesState.data, 'data', [tAddress]),
        ],
      );
    });

    group('addAddress', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionSuccess] when succeeds',
        setUp: () {
          when(mockAddAddressUseCase(any)).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([tAddress]),
          );
        },
        build: () {
          final cubit = buildCubit();
          // Add necessary data for mapping
          return cubit..emit(
            cubit.state.copyWith(
              governoratesState: const BaseState(
                isLoading: false,
                data: [tGov],
              ),
              citiesState: const BaseState(isLoading: false, data: [tCity]),
              selectedGovernorateId: '1',
              selectedCityId: '1',
            ),
          );
        },
        act: (cubit) => cubit.doEvent(
          const AddAddressEvent(
            recipientName: 'John',
            phoneNumber: '012',
            street: 'Street',
          ),
        ),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.addAddressState.isLoading,
            'addLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.addAddressState.isLoading, 'addLoading', false)
              .having((s) => s.addAddressState.data, 'addData', true),
        ],
      );
    });

    group('deleteAddress', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionSuccess] and handles deletingAddressId',
        setUp: () {
          when(mockDeleteAddressUseCase(any)).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const DeleteAddressEvent('1')),
        expect: () => [
          isA<AddressStates>()
              .having((s) => s.deleteAddressState.isLoading, 'loading', true)
              .having((s) => s.deletingAddressId, 'id', '1'),
          isA<AddressStates>()
              .having((s) => s.deleteAddressState.isLoading, 'loading', false)
              .having((s) => s.deleteAddressState.data, 'data', true)
              .having((s) => s.deletingAddressId, 'id', isNull),
        ],
      );
    });

    group('InitEditAddressEvent', () {
      blocTest<AddressCubit, AddressStates>(
        'initializes edit mode by matching names to IDs using AddressMatcher',
        setUp: () {
          when(mockGetGovernoratesUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<GovernorateEntity>>([tGov]),
          );
          when(mockGetCitiesUseCase('1')).thenAnswer(
            (_) async => SuccessBaseResponse<List<CityEntity>>([tCity]),
          );
          when(mockAddressMatcher.matchGovernorate(any, any)).thenReturn('1');
          when(mockAddressMatcher.matchCityByName(any, any)).thenReturn('1');
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const InitEditAddressEvent(tAddress)),
        expect: () => [
          // First emits governorates loading/success
          isA<AddressStates>().having(
            (s) => s.governoratesState.isLoading,
            'gov loading',
            true,
          ),
          isA<AddressStates>().having(
            (s) => s.governoratesState.data,
            'gov data',
            [tGov],
          ),
          // Then emits the final state with matched IDs
          isA<AddressStates>()
              .having((s) => s.selectedGovernorateId, 'gov id', '1')
              .having((s) => s.selectedCityId, 'city id', '1')
              .having((s) => s.autoAddressDetails, 'street', 'Street 1'),
        ],
      );
    });
  });
}
