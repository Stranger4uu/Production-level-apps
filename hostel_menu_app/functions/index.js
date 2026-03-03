const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendMealNotification = functions.firestore
  .document("menus/{menuId}")
  .onUpdate(async (change, context) => {

    const before = change.before.data();
    const after = change.after.data();

    if (before.mealType === after.mealType) {
      return null;
    }

    const mealType = after.mealType;
    const foodName = after.name;

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

    const message = {
      notification: {
        title: "Meal Updated 🍽️",
        body: `${foodName} selected for ${mealType}`
      },
      tokens: tokens
    };

    try {
      const response = await admin.messaging().sendEachForMulticast(message);
      console.log("Successfully sent message:", response);
    } catch (error) {
      console.error("Error sending message:", error);
    }

    return null;
  });