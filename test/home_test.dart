import 'package:architecture_sample/data/repositories/photo_repository_impl.dart';
import 'package:architecture_sample/domain/entities/photo_entity.dart';
import 'package:architecture_sample/domain/repositories/photo_repository.dart';
import 'package:architecture_sample/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns no photos, so the photo tab settles without a network.
class EmptyRepository implements PhotoRepository {
  @override
  Future<List<PhotoEntity>> getPhotos(int page, int perPage) async => const [];
}

void main() {
  testWidgets('the bottom bar switches between the photo and favorite tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [photoRepositoryProvider.overrideWithValue(EmptyRepository())],
        child: const ArchitectureSampleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No photos'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(find.text('No favorite photos yet'), findsOneWidget);
    expect(find.text('No photos'), findsNothing);

    await tester.tap(find.byIcon(Icons.photo));
    await tester.pumpAndSettle();
    expect(find.text('No photos'), findsOneWidget);
  });
}
