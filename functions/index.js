// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// // Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
// exports.myFunction = functions.firestore
//   .document("chat/{messageId}")
//   .onCreate((snapshot, context) => {
//     // Return this function's promise, so this ensures the firebase function
//     // will keep running, until the notification is scheduled.
//     return admin.messaging().sendToTopic("chat", {
//       // Sending a notification message.
//       notification: {
//         title: snapshot.data()["username"],
//         body: snapshot.data()["text"],
//         clickAction: "FLUTTER_NOTIFICATION_CLICK",
//       },
//     });
//   });

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendBookNotification = functions.firestore
  .document('NewBook/{bookId}')
  .onCreate(async (snapshot, context) => {
    const book = snapshot.data();
    const facultyName = book["username"];

    // Fetch the user ID associated with the book
    // const userId = book.userId;

    // Fetch the user's FCM token from the 'fcm' collection based on the user ID
    const fcmSnapshot = await admin.firestore().collection('fcm').doc('admin').get();
    const fcmToken = fcmSnapshot.data().token;

    // Create the notification payload
    const payload = {
      notification: {
        title: "New Recommendation", // Use the user's name as the notification title
        body: "From " + facultyName // Use the book name as the notification body
      }
    };

    // Send the notification to the user's device using the FCM token
    await admin.messaging().sendToDevice(fcmToken, payload);
  });
