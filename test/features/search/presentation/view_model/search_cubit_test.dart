import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_cubit.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_cubit_test.mocks.dart';

@GenerateMocks([SearchProductsUseCase, HiveHelper])
void main() {
  late SearchCubit cubit;
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late MockHiveHelper mockHiveHelper;

  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse(const []),
    );
  });

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    mockHiveHelper = MockHiveHelper();

    // Setup default mock for getData (required in constructor)
    when(
      mockHiveHelper.getData<List<dynamic>>(
        boxName: anyNamed('boxName'),
        key: anyNamed('key'),
      ),
    ).thenAnswer((_) async => null);

    cubit = SearchCubit(mockSearchProductsUseCase, mockHiveHelper);
  });

  tearDown(() {
    cubit.close();
  });

  const tProductEntity = ProductEntity(
    id: '1',
    title: 'Rose',
    imgCover: 'https://example.com/rose.jpg',
    price: 100,
    priceAfterDiscount: 80,
    discount: 20,
    description: 'Beautiful Rose',
  );
  final tProductList = [tProductEntity];

  group('SearchCubit - doEvent', () {
    blocTest<SearchCubit, SearchStates>(
      'emit search query when SearchQueryChangedEvent is dispatched',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('rose')),
      expect: () => [const SearchStates(searchQuery: 'rose')],
    );

    blocTest<SearchCubit, SearchStates>(
      'clear search query when empty string is provided',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('')),
      expect: () => [const SearchStates(searchQuery: '')],
    );
  });

  group('SearchCubit - searchProducts', () {
    blocTest<SearchCubit, SearchStates>(
      'success: emit loading then data',
      setUp: () {
        when(
          mockSearchProductsUseCase(GetProductsParams(search: 'rose')),
        ).thenAnswer((_) async => SuccessBaseResponse(tProductList));
        when(
          mockHiveHelper.cacheData<List<String>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('rose')),
      wait: Duration(milliseconds: 600), // Wait for debounce
      expect: () => [
        const SearchStates(searchQuery: 'rose'),
        SearchStates(
          searchQuery: 'rose',
          searchProductsState: const BaseState(isLoading: true),
        ),
        SearchStates(
          searchQuery: 'rose',
          searchProductsState: BaseState(isLoading: false, data: tProductList),
        ),
        SearchStates(
          searchQuery: 'rose',
          searchProductsState: BaseState(isLoading: false, data: tProductList),
          searchHistory: const ['rose'],
        ),
      ],
      verify: (_) {
        verify(
          mockSearchProductsUseCase(GetProductsParams(search: 'rose')),
        ).called(1);
        verify(
          mockHiveHelper.cacheData<List<String>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).called(1);
      },
    );

    blocTest<SearchCubit, SearchStates>(
      'error: emit loading then error state',
      setUp: () {
        when(
          mockSearchProductsUseCase(GetProductsParams(search: 'invalid')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse<List<ProductEntity>>('Network Error'),
        );
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('invalid')),
      wait: Duration(milliseconds: 600), // Wait for debounce
      expect: () => [
        const SearchStates(searchQuery: 'invalid'),
        const SearchStates(
          searchQuery: 'invalid',
          searchProductsState: BaseState(isLoading: true),
        ),
        const SearchStates(
          searchQuery: 'invalid',
          searchProductsState: BaseState(
            isLoading: false,
            errorMessage: 'Network Error',
          ),
        ),
      ],
      verify: (_) => verify(mockSearchProductsUseCase(any)).called(1),
    );

    blocTest<SearchCubit, SearchStates>(
      'empty results: emit loading then empty data',
      setUp: () {
        when(
          mockSearchProductsUseCase(GetProductsParams(search: 'xyz')),
        ).thenAnswer((_) async => SuccessBaseResponse([]));
      },
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('xyz')),
      wait: Duration(milliseconds: 600), // Wait for debounce
      expect: () => [
        const SearchStates(searchQuery: 'xyz'),
        const SearchStates(
          searchQuery: 'xyz',
          searchProductsState: BaseState(isLoading: true),
        ),
        const SearchStates(
          searchQuery: 'xyz',
          searchProductsState: BaseState(isLoading: false, data: []),
        ),
      ],
    );
  });

  group('SearchCubit - history management', () {
    blocTest<SearchCubit, SearchStates>(
      'GetSearchHistoryEvent: load history from Hive',
      setUp: () {
        when(
          mockHiveHelper.getData<List<dynamic>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => ['rose', 'tulip']);
      },
      build: () {
        final newCubit = SearchCubit(mockSearchProductsUseCase, mockHiveHelper);
        addTearDown(newCubit.close);
        return newCubit;
      },
      expect: () => [
        const SearchStates(
          searchProductsState: BaseState(),
          searchHistory: ['rose', 'tulip'],
        ),
      ],
    );

    blocTest<SearchCubit, SearchStates>(
      'RemoveSearchQueryEvent: remove query from history',
      setUp: () {
        when(
          mockHiveHelper.getData<List<dynamic>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => ['rose', 'tulip', 'lily']);
        when(
          mockHiveHelper.cacheData<List<String>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () {
        final newCubit = SearchCubit(mockSearchProductsUseCase, mockHiveHelper);
        addTearDown(newCubit.close);
        return newCubit;
      },
      seed: () => const SearchStates(
        searchProductsState: BaseState(),
        searchHistory: ['rose', 'tulip', 'lily'],
      ),
      act: (cubit) => cubit.doEvent(const RemoveSearchQueryEvent('tulip')),
      expect: () => [
        const SearchStates(
          searchProductsState: BaseState(),
          searchHistory: ['rose', 'lily'],
        ),
      ],
    );

    blocTest<SearchCubit, SearchStates>(
      'ClearSearchHistoryEvent: clear all history',
      setUp: () {
        when(
          mockHiveHelper.getData<List<dynamic>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => ['rose', 'tulip']);
        when(
          mockHiveHelper.clearBox(boxName: anyNamed('boxName')),
        ).thenAnswer((_) async {});
      },
      build: () {
        final newCubit = SearchCubit(mockSearchProductsUseCase, mockHiveHelper);
        addTearDown(newCubit.close);
        return newCubit;
      },
      seed: () => const SearchStates(
        searchProductsState: BaseState(),
        searchHistory: ['rose', 'tulip'],
      ),
      act: (cubit) => cubit.doEvent(const ClearSearchHistoryEvent()),
      expect: () => [
        const SearchStates(searchProductsState: BaseState(), searchHistory: []),
      ],
      verify: (_) => verify(
        mockHiveHelper.clearBox(boxName: anyNamed('boxName')),
      ).called(1),
    );

    blocTest<SearchCubit, SearchStates>(
      'search history should not exceed 10 items',
      setUp: () {
        final existingHistory = List.generate(10, (i) => 'query$i');
        when(
          mockHiveHelper.getData<List<dynamic>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => existingHistory);
        when(
          mockSearchProductsUseCase(GetProductsParams(search: 'new_query')),
        ).thenAnswer((_) async => SuccessBaseResponse(tProductList));
        when(
          mockHiveHelper.cacheData<List<String>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () {
        final newCubit = SearchCubit(mockSearchProductsUseCase, mockHiveHelper);
        addTearDown(newCubit.close);
        return newCubit;
      },
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('new_query')),
      wait: const Duration(milliseconds: 600),
      verify: (cubit) {
        expect(cubit.state.searchHistory.length, 10);
        expect(cubit.state.searchHistory.first, 'new_query');
        verify(
          mockHiveHelper.cacheData<List<String>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
            value: argThat(
              predicate<List<String>>(
                (list) => list.length == 10 && list.first == 'new_query',
              ),
              named: 'value',
            ),
          ),
        ).called(1);
      },
    );
  });
}
