import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poke_scouter/domain/firebase/battle.dart';
import 'package:poke_scouter/domain/firebase/party.dart';
import 'package:poke_scouter/repository/firestore/firebase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseRepositoryMockProvider =
    Provider((ref) => FirebaseRepositoryMock());

class FirebaseRepositoryMock implements FirebaseRepository {
  @override
  // TODO: implement firestore
  FirebaseFirestore get firestore => throw UnimplementedError();

  @override
  Stream<List<Party>> subscribeParties(String userId) {
    // TODO: implement subscribeParties
    throw UnimplementedError();
  }

  @override
  Future<String> setParty(
      {required String userId,
      required String name,
      required List<String> partyNameList,
      required List<List<String>> divisorList,
      required String memo,
      required Map<String, String> eachMemo}) {
    // TODO: implement setParty
    throw UnimplementedError();
  }

  @override
  Future<QuerySnapshot<Battle>> loadBattles(String userId,
      {required QueryDocumentSnapshot<Battle>? lastReadQueryDocumentSnapshot}) {
    // TODO: implement loadBattles
    throw UnimplementedError();
  }

  @override
  Future<Party?> fetchParty(String userId, String partyId) {
    // TODO: implement fetchParty
    throw UnimplementedError();
  }

  @override
  Future setBattle({
    required String userId,
    required String partyId,
    required List<String> opponentParty,
    required List<String> myParty,
    required List<int> opponentOrder,
    required List<int> myOrder,
    required String memo,
    required Map<String, String> eachMemo,
    required String result,
    required List<int> opponentPartyIds,
  }) {
    // TODO: implement setBattle
    throw UnimplementedError();
  }

  @override
  Future<List<Battle>> fetchBattles(String userId, List<int> opponentPartyIds) {
    // TODO: implement fetchBattles
    throw UnimplementedError();
  }
}
