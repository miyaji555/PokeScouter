import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {
    FieldValue,
} from "@google-cloud/firestore";

export const fetchBattles = functions.https.onCall(async (data, context) => {
    console.log("fetchBattles called with data:");
    // 認証チェック
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
    }

    try {
        const userId = data.userId;
        if (!userId) {
            throw new functions.https.HttpsError("invalid-argument", "The function must be called with one argument \"userId\".");
        }

        const db = admin.firestore();
        const battlesRef = db.collection(`user/${userId}/battle`);
        const snapshot = await battlesRef.limit(10).get();  // 例として10件に制限

        const battles = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        console.log("Fetched battles:", battles);
        return { battles };
    } catch (error) {
        console.error("Error fetching battles:", error);
        throw new functions.https.HttpsError("unknown", "Failed to fetch battles", error);
    }
});

const checkBattleParams = (data: any): string[] => {
    console.log("params", data);
    const requiredParams = ["userId", "partyId", "opponentParty", "myParty", "divisorList", "opponentOrder", "myOrder", "memo", "eachMemo", "result"];
    return requiredParams.filter(param => {
        const value = data[param];
        // value が undefined または null なら欠けているとみなす。空文字、空配列は許容
        return value == null; // `== null` は `value === undefined || value === null` と同等
    });
}

const convertToVector = (pokemonIds: number[]): number[] => {
    // ポケモンの総数に基づく1025次元のベクトルを作成（初期値は0）
    const vector: number[] = new Array(1025).fill(0);

    // ポケモンIDの配列をループして、対応するインデックスの値を1に設定
    pokemonIds.forEach(id => {
        if (id >= 1 && id <= 1025) {
            vector[id - 1] = 1;  // IDが1から始まるので、インデックスはid - 1とする
        }
    });

    return vector;
}

export const setBattle = functions.https.onCall(async (data, context) => {
    // 認証チェック
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
    }

    // パラメータチェック
    const missingParams = checkBattleParams(data);
    if (missingParams.length > 0) {
        throw new functions.https.HttpsError("invalid-argument", `Missing or invalid parameters: ${missingParams.join(", ")}`);
    }
    const userId = data.userId;
    const partyId = data.partyId;
    const opponentParty = data.opponentParty;
    const opponentPartyIds = data.opponentPartyIds;
    const myParty = data.myParty;
    const divisorList = data.divisorList;
    const opponentOrder = data.opponentOrder;
    const myOrder = data.myOrder;
    const memo = data.memo;
    const eachMemo = data.eachMemo;
    const result = data.result;


    try {
        const db = admin.firestore();
        const battleDoc = db.collection(`user/${userId}/battle`).doc();

        const battleData = {
            userId,
            partyId,
            battleId: battleDoc.id,
            opponentParty,
            myParty,
            divisorList6: divisorList[0],
            divisorList5: divisorList[1],
            divisorList4: divisorList[2],
            divisorList3: divisorList[3],
            divisorList2: divisorList[4],
            divisorList1: divisorList[5],
            opponentOrder,
            myOrder,
            memo,
            eachMemo,
            result,
            createdAt: FieldValue.serverTimestamp(),
            embedding_field: FieldValue.vector(convertToVector(opponentPartyIds)),
        };

        await battleDoc.set(battleData);
        return { success: true };
    } catch (error) {
        console.error("Error writing battle:", error);
        throw new functions.https.HttpsError("unknown", "Failed to set battle", error);
    }
});

