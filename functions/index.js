/**
 * Cloud Functions for LeafLine Application
 * Demonstrates both callable and event-triggered serverless functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * CALLABLE FUNCTION: sayHello
 * Simple callable function invoked directly from Flutter
 * Returns a personalized greeting message
 */
exports.sayHello = functions.https.onCall((data, context) => {
  const name = data.name || "User";
  const timestamp = new Date().toISOString();
  
  console.log(`sayHello called for: ${name} at ${timestamp}`);
  
  return {
    message: `Hello, ${name}! Welcome to LeafLine 🌿`,
    timestamp: timestamp,
    success: true,
  };
});

/**
 * CALLABLE FUNCTION: processPlantData
 * Advanced function with authentication and validation
 * Processes plant information and returns recommendations
 */
exports.processPlantData = functions.https.onCall(async (data, context) => {
  // Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated to process plant data."
    );
  }

  const { plantName, wateringFrequency, sunlightLevel } = data;

  // Validate required fields
  if (!plantName || !wateringFrequency) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Plant name and watering frequency are required."
    );
  }

  console.log(`Processing plant: ${plantName}, watering: ${wateringFrequency}x/week, sunlight: ${sunlightLevel}`);

  // Generate intelligent recommendations
  const recommendations = [];
  
  if (wateringFrequency < 2) {
    recommendations.push("Consider watering more frequently for optimal growth");
  } else if (wateringFrequency > 7) {
    recommendations.push("Be careful not to overwater - this could cause root rot");
  }
  
  if (sunlightLevel === "low") {
    recommendations.push("This plant may need more sunlight exposure");
  } else if (sunlightLevel === "high") {
    recommendations.push("Ensure the plant doesn't get scorched by direct sun");
  }

  // Calculate health score (70-100 range)
  const healthScore = Math.floor(Math.random() * 30) + 70;

  const processedData = {
    plantName: plantName,
    wateringFrequency: wateringFrequency,
    sunlightLevel: sunlightLevel || "medium",
    healthScore: healthScore,
    recommendations: recommendations,
    processedAt: admin.firestore.FieldValue.serverTimestamp(),
    processedBy: context.auth.uid,
  };

  return {
    success: true,
    data: processedData,
    message: "Plant data processed successfully!",
  };
});

/**
 * EVENT-TRIGGERED FUNCTION: newUserCreated
 * Automatically executes when a new user document is created
 * Enriches user profile with default fields and logs analytics
 */
exports.newUserCreated = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    const userId = context.params.userId;
    
    console.log("=== New User Created ===");
    console.log(`User ID: ${userId}`);
    console.log(`User Email: ${userData.email || "N/A"}`);
    console.log("========================");

    try {
      // Auto-generate additional profile fields
      await snap.ref.update({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        accountStatus: "active",
        membershipLevel: "basic",
        plantsAdded: 0,
        notificationsEnabled: true,
        profileComplete: false,
      });

      // Log to analytics collection
      await admin.firestore().collection("analytics").add({
        eventType: "user_created",
        userId: userId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        userEmail: userData.email || "N/A",
      });

      console.log(`✅ Successfully enriched user profile: ${userId}`);
      return null;
    } catch (error) {
      console.error("❌ Error processing new user:", error);
      return null;
    }
  });

/**
 * EVENT-TRIGGERED FUNCTION: plantAdded
 * Automatically executes when a plant document is created
 * Updates user statistics and adds metadata
 */
exports.plantAdded = functions.firestore
  .document("plants/{plantId}")
  .onCreate(async (snap, context) => {
    const plantData = snap.data();
    const plantId = context.params.plantId;
    
    console.log("=== New Plant Added ===");
    console.log(`Plant ID: ${plantId}`);
    console.log(`Plant Name: ${plantData.name || "Unknown"}`);
    console.log("=======================");

    try {
      // Update user's plant count if userId exists
      if (plantData.userId) {
        const userRef = admin.firestore().collection("users").doc(plantData.userId);
        await userRef.update({
          plantsAdded: admin.firestore.FieldValue.increment(1),
          lastPlantAddedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log(`📊 Updated plant count for user: ${plantData.userId}`);
      }

      // Add timestamp if not present
      if (!plantData.createdAt) {
        await snap.ref.update({
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          status: "active",
        });
      }

      console.log(`✅ Successfully processed plant: ${plantId}`);
      return null;
    } catch (error) {
      console.error("❌ Error processing new plant:", error);
      return null;
    }
  });

/**
 * EVENT-TRIGGERED FUNCTION: messageUpdated
 * Tracks engagement when messages are liked/updated
 */
exports.messageUpdated = functions.firestore
  .document("messages/{messageId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const messageId = context.params.messageId;

    // Check if likes count changed
    if (before.likes !== after.likes) {
      console.log(`💖 Message ${messageId} likes: ${before.likes} → ${after.likes}`);
      
      // Milestone detection
      if (after.likes >= 10 && before.likes < 10) {
        console.log(`🎉 Message ${messageId} reached 10 likes milestone!`);
        // Could trigger notifications here
      }
    }

    return null;
  });
