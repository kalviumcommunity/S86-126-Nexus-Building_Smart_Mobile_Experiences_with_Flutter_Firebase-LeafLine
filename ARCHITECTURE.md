# LeafLine Firebase Architecture

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App (LeafLine)                │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                      UI Layer                              │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │  LoginScreen  SignupScreen  DashboardScreen              │  │
│  │    (Email)      (Email)      (Plant Notes)                │  │
│  │   (Password)   (Password)    (Add/Edit/Delete)           │  │
│  │                  (Confirm)    (User Info)                 │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ▲                                   │
│                              │                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  AuthWrapper                               │  │
│  │         (StreamBuilder listening to auth state)           │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              ▲                                   │
│                              │                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  Service Layer                             │  │
│  ├─────────────────────────┬─────────────────────────────────┤  │
│  │   AuthService           │   FirestoreService              │  │
│  ├─────────────────────────┼─────────────────────────────────┤  │
│  │ • signUp()              │ • addUserData()                 │  │
│  │ • logIn()               │ • addPlantNote()                │  │
│  │ • logOut()              │ • getUserData()                 │  │
│  │ • getCurrentUser()      │ • getPlantNotesStream()         │  │
│  │ • authStateChanges()    │ • updatePlantNote()             │  │
│  │ • getCurrentUserUID()   │ • deletePlantNote()             │  │
│  └─────────────────────────┴─────────────────────────────────┘  │
│                  ▲                              ▲                │
└──────────────────┼──────────────────────────────┼────────────────┘
                   │                              │
                   │          Firebase            │
                   │                              │
        ┌──────────┴──────────┐        ┌──────────┴──────────┐
        │                     │        │                     │
   ┌────▼─────────────┐  ┌────▼────────────────────┐         │
   │ Firebase Auth    │  │  Cloud Firestore       │         │
   ├──────────────────┤  ├────────────────────────┤         │
   │ Email/Password   │  │                        │         │
   │ User Management  │  │  users/{uid}/          │         │
   │ Session Control  │  │  ├── name              │         │
   │ Auth State       │  │  ├── email             │         │
   │                  │  │  ├── createdAt         │         │
   │                  │  │  └── plant_notes/      │         │
   │                  │  │     ├── plantName      │         │
   │                  │  │     ├── instructions   │         │
   │                  │  │     └── createdAt      │         │
   └──────────────────┘  └────────────────────────┘         │
        ▲                        ▲                           │
        └────────────────────────┴───────────────────────────┘
              Google Firebase Backend (Cloud)
```

---

## Data Flow Diagram

### Sign Up Flow

```
User Input
    │
    ▼
SignupScreen (UI)
    │ → Form Validation
    │
    ▼
AuthService.signUp()
    │ → FirebaseAuth.createUserWithEmailAndPassword()
    │
    ▼
Firebase Auth (Cloud)
    │ → User created ✓
    │
    ▼
FirestoreService.addUserData()
    │ → Firestore.collection('users').doc(uid).set(data)
    │
    ▼
Cloud Firestore (Cloud)
    │ → User document stored ✓
    │
    ▼
DashboardScreen (Redirect)
```

---

### Login Flow

```
User Credentials (Email, Password)
    │
    ▼
LoginScreen (UI)
    │ → Validate Input
    │
    ▼
AuthService.logIn()
    │ → FirebaseAuth.signInWithEmailAndPassword()
    │
    ▼
Firebase Auth (Cloud)
    │ → Credentials verified ✓
    │ → Auth token generated
    │
    ▼
AuthWrapper (StreamBuilder)
    │ → authStateChanges() emits user
    │
    ▼
DashboardScreen (Navigate)
```

---

### Add Plant Note Flow

```
User Input (Plant Name, Care Instructions)
    │
    ▼
DashboardScreen (Dialog UI)
    │ → Validate Input
    │
    ▼
FirestoreService.addPlantNote()
    │ → data = {plantName, careInstructions, createdAt}
    │ → Firestore.collection('users/{uid}/plant_notes').add(data)
    │
    ▼
Cloud Firestore (Cloud)
    │ → Document created ✓
    │
    ▼
StreamBuilder listens to getPlantNotesStream()
    │ → Firestore.collection('users/{uid}/plant_notes').snapshots()
    │
    ▼
ListView automatically updates
    │ → Shows new plant note instantly ✓
```

---

### Real-time Sync Flow

```
Device 1 (User A)           Device 2 (User A)
    │                              │
    ├─ Add Plant Note              │
    │     │                        │
    │     ▼                        │
    │  FirestoreService            │
    │     │                        │
    │     ▼                        │
    │  Cloud Firestore             │
    │     │◄──────────┤            │
    │     │           │            │
    │     └──────────►│ Snapshot   │
    │                 │ Update     │
    │                 ▼            │
    │              StreamBuilder   │
    │                 │            │
    │                 ▼            │
    │              ListView ✓      │
    │              Updates         │
```

---

## Firebase Security Rules Structure

```javascript
Firestore
│
├─ users/ (Collection)
│  │
│  └─ {uid}/ (Document - User's unique ID)
│     │
│     ├─ name: "John Doe"
│     ├─ email: "john@example.com"
│     ├─ createdAt: Timestamp
│     │
│     └─ plant_notes/ (Subcollection)
│        │
│        └─ {noteId}/ (Document - Auto-generated ID)
│           ├─ plantName: "Monstera"
│           ├─ careInstructions: "Water weekly..."
│           └─ createdAt: Timestamp
│
Security Rules:
├─ User can only access /users/{their_uid}
└─ User can only access /users/{their_uid}/plant_notes/*
```

---

## Authentication State Management

```
┌─────────────────────────────────────┐
│   FirebaseAuth.authStateChanges()   │
│          (Stream<User?>)            │
├─────────────────────────────────────┤
│                                     │
│  When user state changes:           │
│  1. User signs up → emits User      │
│  2. User logs in → emits User       │
│  3. User logs out → emits null      │
│  4. App reopens → emits cached User │
│                                     │
└─────────────────────────────────────┘
           ▼ listens
┌─────────────────────────────────────┐
│         AuthWrapper                 │
│    (StreamBuilder listening)        │
├─────────────────────────────────────┤
│  if User != null:                   │
│    → Show DashboardScreen           │
│  else:                              │
│    → Show LoginScreen               │
└─────────────────────────────────────┘
```

---

## CRUD Operations on Plant Notes

### CREATE

```dart
FirestoreService.addPlantNote(uid, data)
  └─ firestore
      .collection('users')
      .doc(uid)
      .collection('plant_notes')
      .add(data)  ✓
```

### READ

```dart
FirestoreService.getPlantNotesStream(uid)
  └─ firestore
      .collection('users')
      .doc(uid)
      .collection('plant_notes')
      .orderBy('createdAt', descending: true)
      .snapshots()  ✓ (Real-time)

FirestoreService.getPlantNote(uid, noteId)
  └─ firestore
      .collection('users')
      .doc(uid)
      .collection('plant_notes')
      .doc(noteId)
      .get()  ✓ (One-time)
```

### UPDATE

```dart
FirestoreService.updatePlantNote(uid, noteId, data)
  └─ firestore
      .collection('users')
      .doc(uid)
      .collection('plant_notes')
      .doc(noteId)
      .update(data)  ✓
```

### DELETE

```dart
FirestoreService.deletePlantNote(uid, noteId)
  └─ firestore
      .collection('users')
      .doc(uid)
      .collection('plant_notes')
      .doc(noteId)
      .delete()  ✓
```

---

## Error Handling Flow

```
User Action
    │
    ▼
Service Method (try)
    │
    ├─ SUCCESS ──────► Return Result
    │
    └─ EXCEPTION
       │
       ├─ FirebaseAuthException
       │  └─ Log: code + message
       │  └─ Show Error Dialog
       │
       ├─ FirebaseException
       │  └─ Log: message
       │  └─ Show Error Dialog
       │
       └─ Generic Exception
          └─ Log: exception
          └─ Show Generic Error
```

---

## Scalability Considerations

```
Single User (Current)
└─ users/{uid}
   └─ plant_notes/{noteId}

Multiple Users (Scalable)
└─ users/
   ├─ {uid_1}/
   │  └─ plant_notes/ (100+ notes)
   │
   ├─ {uid_2}/
   │  └─ plant_notes/ (100+ notes)
   │
   └─ {uid_n}/
      └─ plant_notes/ (100+ notes)

Firestore Benefits:
✓ Auto-scales with users
✓ Indexes on createdAt for efficient queries
✓ Subcollections prevent document size limits
✓ Real-time updates for all users
✓ Offline support available
```

---

## Performance Optimizations

### 1. StreamBuilder Efficiency

```dart
StreamBuilder<QuerySnapshot>(
  stream: _firestoreService.getPlantNotesStream(uid),
  // Only rebuilds when data changes
  // Not on parent widget rebuilds
)
```

### 2. Real-time Ordering

```dart
.orderBy('createdAt', descending: true)
// Sorts at Firebase level
// App receives pre-sorted data
```

### 3. UID-based Queries

```dart
.collection('users').doc(uid)
// Direct access - O(1) lookup
// No need to query all users
```

---

## Deployment Pipeline

```
Local Development
    │ ✓ Test sign up/login
    │ ✓ Test add/edit/delete notes
    │ ✓ Test real-time sync
    │
    ▼
Firebase Console Setup
    │ ✓ Enable Email Auth
    │ ✓ Create Firestore Database
    │ ✓ Apply Security Rules
    │
    ▼
Platform-specific Build
    │ ✓ Android: flutter build apk
    │ ✓ iOS: flutter build ios
    │
    ▼
Testing on Real Devices
    │ ✓ Production Firebase project
    │ ✓ Real user data
    │
    ▼
App Store/Play Store Deployment
    │ ✓ User downloads app
    │ ✓ Cloud backend ready
```

---

This architecture provides a **secure, scalable, and maintainable** foundation for LeafLine's cloud-connected plant care platform! 🌿
