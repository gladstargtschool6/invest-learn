# Premium Google Play Billing

Product IDs:
- `ai_coaching_premium_monthly` — base price $2/month
- `ai_coaching_premium_annual` — base price $20/year

The Flutter client uses `in_app_purchase` and Google Play's localized product pricing. Configure the products as auto-renewing subscriptions in Play Console; the annual plan should have the lower effective yearly price.

## Secure verification required

Set these at build time, never in source control:

```bash
flutter run --dart-define=PREMIUM_VERIFY_ENDPOINT=https://api.example.com/billing/google/verify --dart-define=ACCOUNT_TOKEN=authenticated-user-token
```

The verification endpoint must authenticate the signed-in account, accept the product ID and purchase token, call the Google Play Developer API using service credentials kept only on the backend, and return `{ "entitlement": "PREMIUM_ACTIVE" }` only after verification. Persist subscription state server-side and process Google Play Real-time Developer Notifications for renewal, cancellation, expiration, refund, and revoke events.

The app deliberately remains `FREE` when no verification endpoint is configured. Do not unlock Premium based only on a local flag or client receipt.

## Entitlement states

The backend should return `FREE`, `PREMIUM_ACTIVE`, `PREMIUM_PENDING`, `PREMIUM_CANCELLED`, or `PREMIUM_EXPIRED` and associate the entitlement with the authenticated account, not the device. Preserve coaching history when access expires.

## Admin metrics

Expose server-side aggregates for active, monthly, annual, expired, cancelled, new, and renewing subscriptions plus revenue. Keep plan configuration server-driven for future plans and payment providers.
