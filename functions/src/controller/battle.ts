import * as functions from "firebase-functions";

export const battle = functions.https.onCall((data, context) => {
    return { message: "Hello, Battle!" };
});
