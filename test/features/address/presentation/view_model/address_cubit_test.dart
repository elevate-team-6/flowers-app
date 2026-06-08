import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address/domain/entities/city_entity.dart';
import 'package:flowers_app/features/address/domain/entities/governorate_entity.dart';
import 'package:flowers_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_cities_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/get_governorates_use_case.dart';
import 'package:flowers_app/features/address/domain/use_cases/update_address_use_case.dart';
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
])
void main() {
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockAddAddressUseCase mockAddAddressUseCase;
  late MockUpdateAddressUseCase mockUpdateAddressUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late MockGetGovernoratesUseCase mockGetGovernoratesUseCase;
  late MockGetCitiesUseCase mockGetCitiesUseCase;

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
  });

  AddressCubit buildCubit() => AddressCubit(
    mockGetAddressesUseCase,
    mockAddAddressUseCase,
    mockUpdateAddressUseCase,
    mockDeleteAddressUseCase,
    mockGetGovernoratesUseCase,
    mockGetCitiesUseCase,
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
        act: (cubit) => cubit.doEvent(GetAddressesEvent()),
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

      blocTest<AddressCubit, AddressStates>(
        'emits [loading, error] when getAddresses fails',
        setUp: () {
          when(mockGetAddressesUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<AddressEntity>>('Error'),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetAddressesEvent()),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.addressesState.isLoading,
            'isLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.addressesState.isLoading, 'isLoading', false)
              .having(
                (s) => s.addressesState.errorMessage,
                'errorMessage',
                'Error',
              ),
        ],
      );
    });

    group('addAddress', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionSuccess] and updates addresses when succeeds',
        setUp: () {
          when(mockAddAddressUseCase(any)).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([tAddress]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const AddAddressEvent(tAddress)),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.actionState.isLoading,
            'actionLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.actionState.isLoading, 'actionLoading', false)
              .having((s) => s.actionState.data, 'actionData', true)
              .having((s) => s.addressesState.data, 'listData', [tAddress]),
        ],
      );

      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionError] when fails',
        setUp: () {
          when(mockAddAddressUseCase(any)).thenAnswer(
            (_) async => ErrorBaseResponse<List<AddressEntity>>('Server Error'),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const AddAddressEvent(tAddress)),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.actionState.isLoading,
            'actionLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.actionState.isLoading, 'actionLoading', false)
              .having(
                (s) => s.actionState.errorMessage,
                'errorMessage',
                'Server Error',
              ),
        ],
      );
    });

    group('updateAddress', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionSuccess] when update succeeds',
        setUp: () {
          when(mockUpdateAddressUseCase(any)).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([tAddress]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const UpdateAddressEvent(tAddress)),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.actionState.isLoading,
            'actionLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.actionState.isLoading, 'actionLoading', false)
              .having((s) => s.actionState.data, 'actionData', true)
              .having((s) => s.addressesState.data, 'listData', [tAddress]),
        ],
      );
    });

    group('deleteAddress', () {
      blocTest<AddressCubit, AddressStates>(
        'emits [actionLoading, actionSuccess] when delete succeeds',
        setUp: () {
          when(mockDeleteAddressUseCase(any)).thenAnswer(
            (_) async => SuccessBaseResponse<List<AddressEntity>>([]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const DeleteAddressEvent('1')),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.actionState.isLoading,
            'actionLoading',
            true,
          ),
          isA<AddressStates>()
              .having((s) => s.actionState.isLoading, 'actionLoading', false)
              .having((s) => s.actionState.data, 'actionData', true)
              .having((s) => s.addressesState.data, 'listData', []),
        ],
      );
    });

    group('Governorate and Cities Selection', () {
      blocTest<AddressCubit, AddressStates>(
        'fetches governorates correctly',
        setUp: () {
          when(mockGetGovernoratesUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<GovernorateEntity>>([tGov]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetGovernoratesEvent()),
        expect: () => [
          isA<AddressStates>().having(
            (s) => s.governoratesState.isLoading,
            'isLoading',
            true,
          ),
          isA<AddressStates>().having((s) => s.governoratesState.data, 'data', [
            tGov,
          ]),
        ],
      );

      blocTest<AddressCubit, AddressStates>(
        'clears city and fetches new cities when governorate changes',
        setUp: () {
          when(mockGetCitiesUseCase('1')).thenAnswer(
            (_) async => SuccessBaseResponse<List<CityEntity>>([tCity]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const GovernorateChangedEvent('1')),
        expect: () => [
          isA<AddressStates>()
              .having((s) => s.selectedGovernorateId, 'govId', '1')
              .having((s) => s.selectedCityId, 'cityId', isNull),
          isA<AddressStates>().having(
            (s) => s.citiesState.isLoading,
            'citiesLoading',
            true,
          ),
          isA<AddressStates>().having((s) => s.citiesState.data, 'citiesData', [
            tCity,
          ]),
        ],
      );

      blocTest<AddressCubit, AddressStates>(
        'updates selectedCityId when CityChangedEvent is called',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const CityChangedEvent('100')),
        expect: () => [
          isA<AddressStates>().having((s) => s.selectedCityId, 'cityId', '100'),
        ],
      );
    });

    group('InitEditAddressEvent', () {
      blocTest<AddressCubit, AddressStates>(
        'initializes edit mode by matching names to IDs',
        setUp: () {
          when(mockGetGovernoratesUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<GovernorateEntity>>([tGov]),
          );
          when(mockGetCitiesUseCase('1')).thenAnswer(
            (_) async => SuccessBaseResponse<List<CityEntity>>([tCity]),
          );
        },
        build: buildCubit,
        act: (cubit) => cubit.doEvent(const InitEditAddressEvent(tAddress)),
        expect: () => [
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
          isA<AddressStates>().having(
            (s) => s.autoAddressDetails,
            'street',
            'Street 1',
          ),
          isA<AddressStates>().having(
            (s) => s.selectedGovernorateId,
            'gov id',
            '1',
          ),
          isA<AddressStates>().having(
            (s) => s.citiesState.isLoading,
            'cities loading',
            true,
          ),
          isA<AddressStates>().having(
            (s) => s.citiesState.data,
            'cities data',
            [tCity],
          ),
          isA<AddressStates>().having((s) => s.selectedCityId, 'city id', '1'),
        ],
      );
    });
  });
}
