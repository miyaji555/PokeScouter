import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { FieldValue } from "@google-cloud/firestore";

export const fetchBattles = functions.https.onCall(async (data, context) => {
    // 認証チェック
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
    }

    try {

        // パラメータチェック
        const missingParams = checkFetchBattlesParams(data);
        if (missingParams.length > 0) {
            throw new functions.https.HttpsError("invalid-argument", `Missing or invalid parameters: ${missingParams.join(", ")}`);
        }

        const db = admin.firestore();
        const battlesRef = db.collection(`user/${data.userId}/battle`);

        const snapshot = await battlesRef.startAt().findNearest("embedding_field", FieldValue.vector(convertToVector(data.opponentPartyIds)), {
            limit: 10,
            distanceMeasure: "DOT_PRODUCT"
        }).get();

        const battles = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        console.log("Fetched battles:", battles);
        return { battles };
    } catch (error) {
        console.error("Error fetching battles:", error);
        throw new functions.https.HttpsError("unknown", "Failed to fetch battles", error);
    }
});

const checkFetchBattlesParams = (data: any): string[] => {
    console.log("params", data);
    const requiredParams = ["userId", "opponentPartyIds"];
    return requiredParams.filter(param => {
        const value = data[param];
        // value が undefined または null なら欠けているとみなす。空文字、空配列は許容
        return value == null; // `== null` は `value === undefined || value === null` と同等
    });
}
const checkBattleParams = (data: any): string[] => {
    console.log("params", data);
    const requiredParams = ["userId", "partyId", "opponentParty", "myParty", "opponentOrder", "myOrder", "memo", "eachMemo", "result"];
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
    if (!context.auth || context.auth.uid !== data.userId) {
        throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
    }

    // パラメータチェック
    const missingParams = checkBattleParams(data);
    if (missingParams.length > 0) {
        throw new functions.https.HttpsError("invalid-argument", `Missing or invalid parameters: ${missingParams.join(", ")}`);
    }

    const userId = data.userId;
    const opponentPartyIds = data.opponentPartyIds;

    try {
        const db = admin.firestore();
        const battleDoc = db.collection(`user/${userId}/battle`).doc();

        const battleData = {
            userId,
            partyId: data.partyId,
            battleId: battleDoc.id,
            opponentParty: data.opponentParty,
            myParty: data.myParty,
            opponentOrder: data.opponentOrder,
            myOrder: data.myOrder,
            memo: data.memo,
            eachMemo: data.eachMemo,
            result: data.result,
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

