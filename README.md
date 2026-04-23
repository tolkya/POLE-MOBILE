# POLE-MOBILE

## Objective

Configure the app like a real production app, while temporarily using your ngrok URL as the official API URL.

## Where Config Lives

- Environment parser: [lib/config/environment.dart](lib/config/environment.dart)
- HTTP client: [lib/config/api_client.dart](lib/config/api_client.dart)
- Production env file (simulated with ngrok): [config/env/prod.json](config/env/prod.json)
- Development env file: [config/env/dev.json](config/env/dev.json)

## How Communication Works

1. `Environment.baseUrl` is loaded at build time.
2. Dio uses this value as `baseUrl`.
3. Services call relative endpoints like `/mobile/login` and `/me`.
4. Final URLs are built automatically:
	- Base URL: `https://uneffectuated-immovably-jair.ngrok-free.dev/api`
	- Endpoint: `/me`
	- Final: `https://uneffectuated-immovably-jair.ngrok-free.dev/api/me`

## Production Rules Enforced

`Environment.validate()` runs before app startup and blocks boot when config is invalid.

- URL cannot be empty
- URL must be valid
- URL must use HTTPS
- URL path must end with `/api`

This prevents silent misconfiguration in release builds.

## Build And Install On Phone (Release)

### 1. Build release APK with production config

```bash
flutter build apk --release --dart-define-from-file=config/env/prod.json
```

### 2. Install on connected Android phone

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### 3. Build Play Store artifact (AAB)

```bash
flutter build appbundle --release --dart-define-from-file=config/env/prod.json
```

## Current Simulation Choice

You asked to simulate production with ngrok for now.

- This is already done in [config/env/prod.json](config/env/prod.json).
- Later, only replace the `API_BASE_URL` value with the final API domain.
- No source code change required.

## Why This Is Production-Grade

1. Config is externalized per environment.
2. Startup validation fails fast on invalid API URL.
3. Release artifacts are built with explicit env files.
4. Switching from ngrok to final API is one config edit, not code refactor.

## Optional Local Development Build

If you want a dev build explicitly:

```bash
flutter build apk --debug --dart-define-from-file=config/env/dev.json
```

## Token Auth Reminder

- Login: `POST /mobile/login`
- Token stored securely via `flutter_secure_storage`
- Bearer injected automatically by Dio interceptor on every request

Files:
- [lib/core/services/auth_service.dart](lib/core/services/auth_service.dart)
- [lib/core/services/token_storage_service.dart](lib/core/services/token_storage_service.dart)
- [lib/config/api_client.dart](lib/config/api_client.dart)

## Verification Checklist

1. Build release APK with [config/env/prod.json](config/env/prod.json)
2. Install APK on phone
3. Login should hit `/mobile/login` on ngrok
4. `GET /me` should return authenticated user
