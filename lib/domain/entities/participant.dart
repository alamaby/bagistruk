import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';

@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String billId,
    required String name,
    @Default(false) bool isPaid,
    DateTime? paidAt,

    /// Optional phone number for the WhatsApp deep-link in settlement
    /// messages. Stored as the user entered / imported it; the client
    /// normalises digits and prepends a country code when building the
    /// wa.me URL. Null when the participant was added without a phone
    /// (manual entry without one, or imported from a contact that had
    /// no numbers on file).
    String? phone,
  }) = _Participant;
}
