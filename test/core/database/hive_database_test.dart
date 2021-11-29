import 'package:ambev_track/core/database/database.dart';
import 'package:ambev_track/core/database/hive_database.dart';
import 'package:ambev_track/features/collect/data/models/collect_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<List<int>> {}

void main() {
  late Database database;
  late MockHiveInterface mockHiveInterface;
  late MockBox mockHiveBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockBox();
    when(() => mockHiveInterface.isAdapterRegistered(any())).thenReturn(false);
    database = HiveDatabaseImpl(hive: mockHiveInterface);
  });

  const String tKey = "key";
  const String tBox = "box";

  group('initialize', () {
    test(
      '''should initialize the database''',
      () async {
        when(() => mockHiveInterface.initFlutter()).thenAnswer((_) async {});
        await database.initialize();
        verify(() => mockHiveInterface.initFlutter());
        verify(() => mockHiveInterface.registerAdapter(CollectModelAdapter()));
      },
      skip:
          """Não é possivel fazer a verificação de métodos de extensão[https://github.com/felangel/mocktail/tree/main/packages/mocktail#why-cant-i-stubverify-extension-methods-properly]""",
    );
  });

  group('get', () {
    test(
      '''should return the data saved in the database''',
      () async {
        when(() => mockHiveInterface.openBox<List<int>>(any()))
            .thenAnswer((_) async => mockHiveBox);

        when(() => mockHiveBox.get(any())).thenReturn([0]);
        final result =
            await database.get<String, List>(boxName: tBox, key: tKey);
        verify(() => mockHiveBox.get(tKey));
        expect(result, equals([0]));
      },
    );
  });

  group('put', () {
    test(
      '''should save the data in the database''',
      () async {
        final tData = [0];
        when(() => mockHiveInterface.openBox<List<int>>(any()))
            .thenAnswer((_) async => mockHiveBox);

        when(() => mockHiveBox.put(any(), any())).thenAnswer((_) async {});
        await database.put<String, List>(
            boxName: tBox, key: tKey, value: tData);
        verify(() => mockHiveBox.put(tKey, tData));
      },
    );
  });

  group('delete', () {
    test(
      '''should delete a data from the database''',
      () async {
        when(() => mockHiveInterface.openBox<List<int>>(any()))
            .thenAnswer((_) async => mockHiveBox);

        when(() => mockHiveBox.delete(any())).thenAnswer((_) async {});
        await database.delete<String, List<int>>(boxName: tBox, key: tKey);
        verify(() => mockHiveBox.delete(tKey));
      },
    );
  });
}
