import * as functions from "firebase-functions";
import * as firebaseAdmin from "firebase-admin";
import { fetchBattles } from "./controller/battle";

export { fetchBattles };


firebaseAdmin.initializeApp(functions.config().firebase);

exports.deleteUserAndData = functions.auth.user().onDelete(async (user) => {
  const db = firebaseAdmin.firestore();

  // Get the user document
  const userDoc = db.collection("user").doc(user.uid);

  // Get subcollections 'party' and 'battle'
  const partyCollection = userDoc.collection("party");
  const battleCollection = userDoc.collection("battle");

  // Delete subcollections
  await deleteCollection(db, partyCollection);
  await deleteCollection(db, battleCollection);

  // Delete the user document
  await userDoc.delete();
});

/**
 * Function to delete all documents in a collection.
 *
 * @function
 * @param {Object} _db - The Firestore database instance.
 * @param {Object} collection - The collection to delete.
 * @return {Promise} A promise that resolves when all documents in the collection have been deleted.
 */
async function deleteCollection(
  _db: firebaseAdmin.firestore.Firestore,
  collection: firebaseAdmin.firestore.CollectionReference<firebaseAdmin.firestore.DocumentData>
) {
  const docs = await collection.listDocuments();

  for (const doc of docs) {
    await doc.delete();
  }
}