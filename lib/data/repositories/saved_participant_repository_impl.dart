import '../../core/error/exception_mapper.dart';
import '../../core/error/result.dart';
import '../../domain/entities/saved_participant.dart';
import '../../domain/repositories/i_saved_participant_repository.dart';
import '../datasources/saved_participant_remote_datasource.dart';

class SavedParticipantRepositoryImpl implements ISavedParticipantRepository {
  SavedParticipantRepositoryImpl(this._ds);

  final SavedParticipantRemoteDataSource _ds;

  @override
  Future<Result<List<SavedParticipant>>> listSuggestions({int limit = 8}) =>
      guardAsync(
        () async => (await _ds.listSuggestions(
          limit: limit,
        )).map((d) => d.toEntity()).toList(growable: false),
      );

  @override
  Future<Result<void>> bump({required String name, required String phone}) =>
      guardAsync(() => _ds.bump(name: name, phone: phone));
}
