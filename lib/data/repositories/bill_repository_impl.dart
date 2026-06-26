import '../../core/error/exception_mapper.dart';
import '../../core/error/result.dart';
import '../../domain/entities/assignment.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/deleted_bill.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/participant.dart';
import '../../domain/repositories/i_bill_repository.dart';
import '../datasources/bill_remote_datasource.dart';
import '../dtos/assignment_dto.dart';
import '../dtos/bill_dto.dart';
import '../dtos/item_dto.dart';
import '../dtos/participant_dto.dart';

class BillRepositoryImpl implements IBillRepository {
  BillRepositoryImpl(this._ds);
  final BillRemoteDataSource _ds;

  @override
  Future<Result<List<Bill>>> listBills({DateTime? createdAfter}) => guardAsync(
    () async => (await _ds.listBills(
      createdAfter: createdAfter,
    )).map((d) => d.toEntity()).toList(growable: false),
  );

  @override
  Future<Result<Bill>> getBill(String id) =>
      guardAsync(() async => (await _ds.getBill(id)).toEntity());

  @override
  Future<Result<Bill>> createBill(Bill bill) async {
    final authResult = await _ds.authEnsureSignedIn();
    if (authResult is ResultFailure<String>) {
      return Result.failure(authResult.failure);
    }
    return guardAsync(
      () async => (await _ds.upsertBill(BillDto.fromEntity(bill))).toEntity(),
    );
  }

  @override
  Future<Result<Bill>> updateBill(Bill bill) => createBill(bill);

  @override
  Future<Result<void>> deleteBill(String id) =>
      guardAsync(() => _ds.deleteBill(id));

  @override
  Future<Result<void>> restoreDeletedBill(String id) =>
      guardAsync(() => _ds.restoreDeletedBill(id));

  @override
  Future<Result<void>> ensureSignedIn() async {
    final res = await _ds.authEnsureSignedIn();
    if (res is ResultFailure<String>) {
      return Result.failure(res.failure);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<List<DeletedBill>>> listDeletedBills() => guardAsync(
    () async => (await _ds.listDeletedBills())
        .map(
          (d) => DeletedBill(
            id: d.id,
            title: d.title,
            totalAmount: d.totalAmount,
            currencyCode: d.currencyCode,
            isSettled: d.isSettled,
            createdAt: d.createdAt,
            deletedAt: d.deletedAt,
            deleteExpiresAt: d.deleteExpiresAt,
          ),
        )
        .toList(growable: false),
  );

  @override
  Future<Result<List<Item>>> listItems(String billId) => guardAsync(
    () async => (await _ds.listItems(
      billId,
    )).map((d) => d.toEntity()).toList(growable: false),
  );

  @override
  Future<Result<List<Item>>> upsertItems(List<Item> items) => guardAsync(
    () async => (await _ds.upsertItems(
      items.map(ItemDto.fromEntity).toList(),
    )).map((d) => d.toEntity()).toList(growable: false),
  );

  @override
  Future<Result<List<Participant>>> listParticipants(String billId) =>
      guardAsync(
        () async => (await _ds.listParticipants(
          billId,
        )).map((d) => d.toEntity()).toList(growable: false),
      );

  @override
  Future<Result<Participant>> upsertParticipant(Participant participant) =>
      guardAsync(
        () async => (await _ds.upsertParticipant(
          ParticipantDto.fromEntity(participant),
        )).toEntity(),
      );

  @override
  Future<Result<void>> deleteParticipant(String participantId) =>
      guardAsync(() => _ds.deleteParticipant(participantId));

  @override
  Future<Result<List<Assignment>>> listAssignments(String billId) => guardAsync(
    () async => (await _ds.listAssignments(
      billId,
    )).map((d) => d.toEntity()).toList(growable: false),
  );

  @override
  Future<Result<List<Assignment>>> replaceAssignments(
    String billId,
    List<Assignment> assignments,
  ) => guardAsync(
    () async => (await _ds.replaceAssignments(
      billId,
      assignments.map(AssignmentDto.fromEntity).toList(),
    )).map((d) => d.toEntity()).toList(growable: false),
  );
}
