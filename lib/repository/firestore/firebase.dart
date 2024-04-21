import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:poke_scouter/constants/firestore.dart';
import 'package:poke_scouter/domain/firebase/battle.dart';
import 'package:poke_scouter/domain/firebase/party.dart';
import 'package:poke_scouter/repository/firestore/refs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseRepositoryProvider =
    Provider<FirebaseRepository>((ref) => FirebaseRepository());

class FirebaseRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> setParty(
      {required String userId,
      required String name,
      required List<String> partyNameList,
      required List<List<String>> divisorList,
      required String memo,
      required Map<String, String> eachMemo}) async {
    final partyDoc = partiesRef(userId: userId).doc();
    final party = Party(
        userId: userId,
        partyId: partyDoc.id,
        name: name,
        partyNameList: partyNameList,
        divisorList6: divisorList[0],
        divisorList5: divisorList[1],
        divisorList4: divisorList[2],
        divisorList3: divisorList[3],
        divisorList2: divisorList[4],
        divisorList1: divisorList[5],
        memo: memo,
        eachMemo: eachMemo);
    await partyDoc.set(party);
    return partyDoc.id;
  }

  // Future setBattle(
  //     {required String userId,
  //     required String partyId,
  //     required List<String> opponentParty,
  //     required List<String> myParty,
  //     required List<List<String>> divisorList,
  //     required List<int> opponentOrder,
  //     required List<int> myOrder,
  //     required String memo,
  //     required Map<String, String> eachMemo,
  //     required String result}) async {
  //   final battleDoc = battlesRef(userId: userId).doc();

  //   final battle = Battle(
  //       userId: userId,
  //       partyId: partyId,
  //       battleId: battleDoc.id,
  //       opponentParty: opponentParty,
  //       myParty: myParty,
  //       divisorList6: divisorList[0],
  //       divisorList5: divisorList[1],
  //       divisorList4: divisorList[2],
  //       divisorList3: divisorList[3],
  //       divisorList2: divisorList[4],
  //       divisorList1: divisorList[5],
  //       opponentOrder: opponentOrder,
  //       myOrder: myOrder,
  //       memo: memo,
  //       eachMemo: eachMemo,
  //       result: result);
  //   await battleDoc.set(battle);
  // }

  Future<void> setBattle({
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
  }) async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('setBattle');
    try {
      final response = await callable.call({
        'userId': userId,
        'partyId': partyId,
        'opponentParty': opponentParty,
        'myParty': myParty,
        'opponentOrder': opponentOrder,
        'myOrder': myOrder,
        'memo': memo,
        'eachMemo': eachMemo,
        'result': result,
        'opponentPartyIds': opponentPartyIds,
      });
      print('Function returned: ${response.data}');
    } catch (e) {
      print('Caught Firebase Functions Exception:');
      print(e);
    }
  }

  Stream<List<Party>> subscribeParties(String userId) {
    final collectionStream = partiesRef(userId: userId)
        .orderBy(kFieldPartyCreatedAt, descending: true)
        .snapshots();
    return collectionStream
        .map((qs) => qs.docs.map((qds) => qds.data()).toList());
  }

  Future<Party?> fetchParty(String userId, String partyId) async {
    final qs = await partyRef(userId: userId, partyId: partyId).get();
    return qs.data();
  }

  // Future<List<Battle>> fetchBattles(String userId) async {
  //   final qs =
  //       await battlesRef(userId: userId).limit(kLimitFetchAllBattles).get();
  //   return qs.docs.map((qds) => qds.data()).toList();
  // }

  Future<List<Battle>> fetchBattles(
      String userId, List<int> opponentPartyIds) async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('fetchBattles');
    try {
      final result = await callable.call(<String, dynamic>{
        'userId': userId,
        'opponentPartyIds': opponentPartyIds
      });
      print('The function returned: ${result.data}');

      final List<Battle> battles = (result.data['battles'] as List)
          .map(
              (item) => Battle.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();

      return battles;
    } catch (e) {
      print('Caught Firebase Functions Exception:');
      print(e);
      return [];
    }
  }

  Future<QuerySnapshot<Battle>> loadBattles(
    String userId, {
    required QueryDocumentSnapshot<Battle>? lastReadQueryDocumentSnapshot,
  }) async {
    var query = battlesRef(userId: userId)
        .orderBy(kFieldBattleCreatedAt, descending: true)
        .limit(kLimitLoadBattles);
    final qds = lastReadQueryDocumentSnapshot;
    if (qds != null) {
      query = query.startAfterDocument(qds);
    }
    return query.get();
  }
}
