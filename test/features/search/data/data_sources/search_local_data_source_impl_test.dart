import 'package:flowers_app/config/cache/hive_helper.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/features/search/data/data_sources/search_local_data_source_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_local_data_source_impl_test.mocks.dart';

@GenerateMocks([HiveHelper])
void main() {
  late SearchLocalDataSourceImpl dataSource;
  late MockHiveHelper mockHiveHelper;

  setUp(() {
    mockHiveHelper = MockHiveHelper();
    dataSource = SearchLocalDataSourceImpl(mockHiveHelper);
  });

  group('SearchLocalDataSourceImpl', () {
    test('getSearchHistory: return list of strings from Hive', () async {
      // Arrange
      final tHistory = ['rose', 'tulip'];
      when(
        mockHiveHelper.getData<List<dynamic>>(
          boxName: AppKeys.searchHistoryBox,
          key: AppKeys.searchHistoryKey,
        ),
      ).thenAnswer((_) async => tHistory);

      // Act
      final result = await dataSource.getSearchHistory();

      // Assert
      expect(result, tHistory);
      verify(
        mockHiveHelper.getData<List<dynamic>>(
          boxName: AppKeys.searchHistoryBox,
          key: AppKeys.searchHistoryKey,
        ),
      ).called(1);
    });

    test(
      'getSearchHistory: return empty list when Hive returns null',
      () async {
        // Arrange
        when(
          mockHiveHelper.getData<List<dynamic>>(
            boxName: anyNamed('boxName'),
            key: anyNamed('key'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        final result = await dataSource.getSearchHistory();

        // Assert
        expect(result, []);
      },
    );

    test('saveSearchHistory: call cacheData with correct params', () async {
      // Arrange
      final tHistory = ['rose'];
      when(
        mockHiveHelper.cacheData(
          boxName: anyNamed('boxName'),
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await dataSource.saveSearchHistory(tHistory);

      // Assert
      verify(
        mockHiveHelper.cacheData(
          boxName: AppKeys.searchHistoryBox,
          key: AppKeys.searchHistoryKey,
          value: tHistory,
        ),
      ).called(1);
    });

    test('clearSearchHistory: call clearBox with correct boxName', () async {
      // Arrange
      when(
        mockHiveHelper.clearBox(boxName: anyNamed('boxName')),
      ).thenAnswer((_) async {});

      // Act
      await dataSource.clearSearchHistory();

      // Assert
      verify(
        mockHiveHelper.clearBox(boxName: AppKeys.searchHistoryBox),
      ).called(1);
    });
  });
}
