# FreshFlow - Supabase Integration

This Flutter app is now configured to connect to Supabase!

## Setup Instructions

### 1. Get Your Supabase Credentials

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Select your project
3. Go to **Project Settings** → **API**
4. Copy your:
   - **Project URL**
   - **Anon/Public Key**

### 2. Configure Environment Variables

Edit the `.env` file in the root directory:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

### 3. Install Dependencies

Run the following command to install all required packages:

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                      # App entry point with Supabase initialization
├── config/
│   └── supabase_config.dart       # Supabase configuration helper
└── services/
    ├── auth_service.dart          # Authentication methods
    └── database_service.dart      # Database CRUD operations
```

## Usage Examples

### Authentication

```dart
import 'package:fresh_flow/services/auth_service.dart';

final authService = AuthService();

// Sign up
await authService.signUp(
  email: 'user@example.com',
  password: 'password123',
);

// Sign in
await authService.signIn(
  email: 'user@example.com',
  password: 'password123',
);

// Sign out
await authService.signOut();
```

### Database Operations

```dart
import 'package:fresh_flow/services/database_service.dart';

final dbService = DatabaseService();

// Insert data
await dbService.insertData(
  table: 'your_table',
  data: {'name': 'Fresh Produce', 'quantity': 10},
);

// Fetch all records
final records = await dbService.fetchAll('your_table');

// Update data
await dbService.updateData(
  table: 'your_table',
  id: 'record-id',
  data: {'quantity': 15},
);

// Delete data
await dbService.deleteData(
  table: 'your_table',
  id: 'record-id',
);
```

### Real-time Subscriptions

```dart
final channel = dbService.subscribeToTable(
  table: 'your_table',
  onData: (payload) {
    print('Change detected: ${payload.newRecord}');
  },
);

// Don't forget to unsubscribe when done
await channel.unsubscribe();
```

## Important Notes

- Never commit your `.env` file with real credentials
- The `.env` file is already added to `.gitignore`
- Replace `'your_table'` in examples with your actual table names
- Make sure your Supabase tables have proper Row Level Security (RLS) policies

## Next Steps

1. Set up your database schema in Supabase
2. Configure Row Level Security policies
3. Create your custom services and models
4. Build your app screens and features

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Flutter Documentation](https://docs.flutter.dev)
