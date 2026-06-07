import 'package:bloc_test/bloc_test.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/base_state/base_state.dart';
import 'package:flowers_app/core/entities/product_entity.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/search/domain/use_cases/clear_search_history_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/get_search_history_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/remove_search_query_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/save_search_query_use_case.dart';
import 'package:flowers_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_bloc.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([
  SearchProductsUseCase,
  GetSearchHistoryUseCase,
  SaveSearchHistoryUseCase,
  ClearSearchHistoryUseCase,
  RemoveSearchQueryUseCase,
])
void main() {
  late SearchBloc bloc;
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late MockGetSearchHistoryUseCase mockGetSearchHistoryUseCase;
  late MockSaveSearchHistoryUseCase mockSaveSearchHistoryUseCase;
  late MockClearSearchHistoryUseCase mockClearSearchHistoryUseCase;
  late MockRemoveSearchQueryUseCase mockRemoveSearchQueryUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse(const []),
    );
  });

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    mockGetSearchHistoryUseCase = MockGetSearchHistoryUseCase();
    mockSaveSearchHistoryUseCase = MockSaveSearchHistoryUseCase();
    mockClearSearchHistoryUseCase = MockClearSearchHistoryUseCase();
    mockRemoveSearchQueryUseCase = MockRemoveSearchQueryUseCase();

    when(mockGetSearchHistoryUseCase()).thenAnswer((_) async => []);

    bloc = SearchBloc(
      mockSearchProductsUseCase,
      mockGetSearchHistoryUseCase,
      mockSaveSearchHistoryUseCase,
      mockClearSearchHistoryUseCase,
      mockRemoveSearchQueryUseCase,
    );
  });

  tearDown(() {
    bloc.close();
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

  group('SearchBloc - Events', () {
    blocTest<SearchBloc, SearchStates>(
      'emit search query when SearchQueryChangedEvent is dispatched',
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChangedEvent('rose')),
      expect: () => [const SearchStates(searchQuery: 'rose')],
    );

    blocTest<SearchBloc, SearchStates>(
      'clear search query and products when empty string is provided',
      seed: () => SearchStates(
        searchQuery: 'rose',
        searchProductsState: BaseState(data: tProductList),
      ),
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChangedEvent('')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        const SearchStates(
          searchQuery: '',
          searchProductsState: BaseState(
            data: [
              ProductEntity(
                id: '1',
                title: 'Rose',
                imgCover: 'https://example.com/rose.jpg',
                price: 100,
                priceAfterDiscount: 80,
                discount: 20,
                description: 'Beautiful Rose',
              ),
            ],
          ),
        ),
        const SearchStates(searchQuery: '', searchProductsState: BaseState()),
      ],
    );
  });

  group('SearchBloc - searchProducts', () {
    blocTest<SearchBloc, SearchStates>(
      'success: emit loading then data',
      setUp: () {
        when(
          mockSearchProductsUseCase(GetProductsParams(search: 'rose')),
        ).thenAnswer((_) async => SuccessBaseResponse(tProductList));
        when(mockSaveSearchHistoryUseCase(any)).thenAnswer((_) async {});
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const SearchQueryChangedEvent('rose')),
      wait: const Duration(milliseconds: 600),
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
    );
  });

  group('SearchBloc - history management', () {
    blocTest<SearchBloc, SearchStates>(
      'RemoveSearchQueryEvent: remove query from history',
      setUp: () {
        when(mockRemoveSearchQueryUseCase(any, any)).thenAnswer((_) async {});
      },
      build: () => bloc,
      seed: () => const SearchStates(searchHistory: ['rose', 'tulip']),
      act: (bloc) => bloc.add(const RemoveSearchQueryEvent('tulip')),
      expect: () => [
        const SearchStates(searchHistory: ['rose']),
      ],
    );

    blocTest<SearchBloc, SearchStates>(
      'ClearSearchHistoryEvent: clear all history',
      setUp: () {
        when(mockClearSearchHistoryUseCase()).thenAnswer((_) async {});
      },
      build: () => bloc,
      seed: () => const SearchStates(searchHistory: ['rose', 'tulip']),
      act: (bloc) => bloc.add(const ClearSearchHistoryEvent()),
      expect: () => [const SearchStates(searchHistory: [])],
    );
  });
}
