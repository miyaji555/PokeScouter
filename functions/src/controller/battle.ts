import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

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
