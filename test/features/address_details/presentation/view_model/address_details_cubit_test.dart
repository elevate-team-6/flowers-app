import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/address_details/domain/entities/address_entity.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/get_addresses_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/initialize_default_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/select_default_address_use_case.dart';
import 'package:flowers_app/features/address_details/domain/use_cases/validate_delivery_location_use_case.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_state.dart';

import 'address_details_cubit_test.mocks.dart';

@GenerateMocks([
  InitializeDefaultAddressUseCase,
  GetAddressesUseCase,
  SelectDefaultAddressUseCase,
  ValidateDeliveryLocationUseCase,
])
void main() {
  late MockInitializeDefaultAddressUseCase mockInitializeUseCase;
  late MockGetAddressesUseCase mockGetAddressesUseCase;
  late MockSelectDefaultAddressUseCase mockSelectAddressUseCase;
  late MockValidateDeliveryLocationUseCase mockValidateLocationUseCase;

  late AddressDetailsCubit cubit;

  const address = AddressEntity(
    id: '1',
    recipientName: 'Youssef',
    phoneNumber: '01000000000',
    street: 'Street',
    city: 'Cairo',
    area: 'Nasr City',
    latitude: '30.0',
    longitude: '31.0',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>([]),
    );

    provideDummy<BaseResponse<AddressEntity?>>(
      SuccessBaseResponse<AddressEntity?>(null),
    );

    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(null));
  });

  setUp(() {
    mockInitializeUseCase = MockInitializeDefaultAddressUseCase();
    mockGetAddressesUseCase = MockGetAddressesUseCase();
    mockSelectAddressUseCase = MockSelectDefaultAddressUseCase();
    mockValidateLocationUseCase = MockValidateDeliveryLocationUseCase();

    cubit = AddressDetailsCubit(
      mockInitializeUseCase,
      mockGetAddressesUseCase,
      mockSelectAddressUseCase,
      mockValidateLocationUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('InitializeAddressDetailsEvent', () {
    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'emits loading then noAddresses when addresses are empty',
      build: () {
        when(
          mockGetAddressesUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse<List<AddressEntity>>([]));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(InitializeAddressDetailsEvent()),
      expect: () => [
        const AddressDetailsState(
          status: AddressDetailsStatus.loading,
        ).copyWith(defaultAddressState: BaseState(isLoading: true)),
        const AddressDetailsState(
          status: AddressDetailsStatus.noAddresses,
          addresses: [],
        ),
      ],
    );

    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'emits success when addresses and default address are loaded',
      build: () {
        when(mockGetAddressesUseCase()).thenAnswer(
          (_) async => SuccessBaseResponse<List<AddressEntity>>([address]),
        );

        when(
          mockInitializeUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse<AddressEntity?>(address));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(InitializeAddressDetailsEvent()),
      expect: () => [
        isA<AddressDetailsState>().having(
          (s) => s.status,
          'status',
          AddressDetailsStatus.loading,
        ),
        isA<AddressDetailsState>()
            .having((s) => s.status, 'status', AddressDetailsStatus.success)
            .having((s) => s.addresses.length, 'addresses', 1)
            .having((s) => s.defaultAddressState.data, 'default', address),
      ],
    );

    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'emits error when getAddresses fails',
      build: () {
        when(
          mockGetAddressesUseCase(),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(InitializeAddressDetailsEvent()),
      expect: () => [
        isA<AddressDetailsState>().having(
          (s) => s.status,
          'status',
          AddressDetailsStatus.loading,
        ),
        isA<AddressDetailsState>().having(
          (s) => s.status,
          'status',
          AddressDetailsStatus.error,
        ),
      ],
    );
  });

  group('SelectAddressEvent', () {
    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'updates selected address successfully',
      build: () {
        when(
          mockSelectAddressUseCase(any),
        ).thenAnswer((_) async => SuccessBaseResponse<void>(null));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(SelectAddressEvent(address)),
      expect: () => [
        isA<AddressDetailsState>()
            .having((s) => s.status, 'status', AddressDetailsStatus.success)
            .having((s) => s.defaultAddressState.data, 'address', address),
      ],
    );

    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'emits error when select address fails',
      build: () {
        when(
          mockSelectAddressUseCase(any),
        ).thenAnswer((_) async => ErrorBaseResponse('error'));

        return cubit;
      },
      act: (cubit) => cubit.doEvent(SelectAddressEvent(address)),
      expect: () => [
        isA<AddressDetailsState>().having(
          (s) => s.status,
          'status',
          AddressDetailsStatus.error,
        ),
      ],
    );
  });

  group('ValidateLocationEvent', () {
    blocTest<AddressDetailsCubit, AddressDetailsState>(
      'emits checking then enabled',
      build: () {
        when(
          mockValidateLocationUseCase(),
        ).thenAnswer((_) async => DeliveryLocationStatus.enabled);

        return cubit;
      },
      act: (cubit) => cubit.doEvent(ValidateLocationEvent()),
      expect: () => [
        isA<AddressDetailsState>().having(
          (s) => s.locationStatus,
          'status',
          DeliveryLocationStatus.checking,
        ),
        isA<AddressDetailsState>().having(
          (s) => s.locationStatus,
          'status',
          DeliveryLocationStatus.enabled,
        ),
      ],
    );
  });
}
