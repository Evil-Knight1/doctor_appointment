// firebase-messaging-sw.js
// This service worker is required for Firebase Cloud Messaging (FCM)
// to work in a web browser (background push notifications).

// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
firebase.initializeApp({
  apiKey: 'AIzaSyBme-bMChzdn3wlqF7pKz8i84Ab4ptIpXU',
  authDomain: 'medlink-cc852.firebaseapp.com',
  projectId: 'medlink-cc852',
  storageBucket: 'medlink-cc852.firebasestorage.app',
  messagingSenderId: '419065403494',
  appId: '1:419065403494:web:691c9886d01cef884ff5a7',
  measurementId: 'G-B4MZHGTW1K',
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages.
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification?.title || payload.data?.title || 'MedLink';
  const notificationOptions = {
    body: payload.notification?.body || payload.data?.message || '',
    icon: '/icons/Icon-192.png',
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
