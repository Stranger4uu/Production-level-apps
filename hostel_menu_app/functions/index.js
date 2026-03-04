const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMenuNotification = functions.firestore
  .document("notifications/{id}")
  .onCreate(async (snap, context) => {

    const data = snap.data();

    const title = data.title;
    const body = data.body;

    const usersSnapshot = await admin.firestore()
      .collection("users")
      .get();

    const tokens = [];

    usersSnapshot.forEach(doc => {
      const token = doc.data().fcmToken;

      if (token) {
        tokens.push(token);
      }
    });

    if (tokens.length === 0) {
      console.log("No tokens found");
      return null;
    }

    const payload = {
      notification: {
        title: title,
        body: body,
      }
    };

    return admin.messaging().sendEachForMulticast({
      tokens: tokens,
      notification: {
        title: title,
        body: body,
      },
    });
  });