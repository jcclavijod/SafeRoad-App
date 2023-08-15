const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializar Firebase Admin SDK
admin.initializeApp(functions.config().functions);

// Cloud Function para asignar solicitud al mecánico
exports.sendNotification = functions.firestore
    .document("requests/{requestsId}")
    .onCreate(async (data, context) => {
      // Obtener los datos de la solicitud y el mecánico
      const mechanicId = "BEdPsCRFCAegeUUMlZtO1Vw9Unk1";
      const mechanicDocRef = admin.firestore().doc(`mecanicos/${mechanicId}`);
      const mechanicDoc = await mechanicDocRef.get();
      const mechanicData = mechanicDoc.data();
      const mechanicToken = mechanicData.token;
      // Construir el mensaje de la notificación
      const payload = {
        notification: {
          title: "Nueva solicitud asignada",
          body: "Necesito un mecanico en mi ubicación urgente...",
          priority: "high",
          sound: "default",
        },
        data: {
          click_action: "FLUTTER_ NOTIFICATION_CLICK",
        },
      };

      // Enviar la notificación a través de FCM
      try {
        await admin.messaging().sendToDevice(mechanicToken, payload);
        console.log("Notificación enviada al mecánico");
      } catch (error) {
        console.error("Error al enviar la notificación:", error);
        throw error;
      }

      // Devolver una respuesta exitosa
      return {success: true};
    });

