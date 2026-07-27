# Design: Handmade Ceramics Online Store

## 1. Overview

A B2C online store for a single handmade-ceramics business. Shoppers browse a
product catalog, manage a cart, and check out with real card payment via a
third-party gateway, either as a guest or an optional registered account.
Staff use a separate admin console to manage the catalog, inventory, and
order fulfillment. The system decomposes into two browser-facing surfaces
(storefront, admin console) sharing one backend API and database, because
the storefront and admin console have different user populations, exposure
(public internet vs. staff-only), and lifecycles.

## 2. Components

- **ceramics-webapp** (`web-application`) — the public storefront: catalog
browsing, search, cart, checkout, and optional shopper account/order
history.
- **ceramics-admin-webapp** (`web-application`) — the staff-only back office:
catalog/inventory management and order/fulfillment management.
- **ceramics-api** (`service`) — the single backend: product catalog, cart,
checkout/payment orchestration, order management, and admin operations. It
owns the store's data and is the only component that talks to Stripe and
the email provider.
- **ceramics-db** — the Postgres database owned by `ceramics-api` (product
catalog, variants/stock, carts, orders, addresses).

## 3. Capabilities

### ceramics-webapp

- Browse the catalog by category/collection, search, sort/filter (FR-1–FR-5).
- View product detail with variants, images, and stock status; sold-out and
one-of-a-kind items reflected in the UI (FR-3, FR-6, FR-7).
- Manage a cart: add/update/remove items, quantity vs. stock validation,
running subtotal (FR-8–FR-12).
- Guest or account checkout: shipping/contact details, flat-rate shipping,
tax display, payment via the gateway, confirmation screen (FR-13–FR-21).
- Optional shopper account: register/sign in/out, view order history, save
addresses (FR-22–FR-25).

### ceramics-admin-webapp

- View and filter the order list by status; view full order detail
including status history (FR-26, FR-27).
- Update order fulfillment status and tracking number, triggering shopper
notification; issue refunds/cancellations (FR-28, FR-29).
- Create/edit/retire products and variants; adjust stock counts; mark
featured or one-of-a-kind items (FR-30–FR-32).
- Accessible to authenticated staff (admin role) only (FR-33).

### ceramics-api

- Catalog read model: products, categories/collections, variants, stock,
search/sort/filter, one-of-a-kind delisting (FR-1–FR-7).
- Cart service: session/account-scoped cart, stock-aware add/update/remove,
subtotal calculation (FR-8–FR-12).
- Checkout orchestration: shipping-fee rule, destination-based tax
calculation, stock/price re-validation, Stripe payment, order creation,
stock decrement, confirmation email (FR-13–FR-21).
- Shopper account operations: registration/auth integration, order history,
saved addresses (FR-22–FR-25).
- Order management operations for admins: list/filter, detail, status
update with tracking, refund/cancel with stock restoration
(FR-26–FR-29).
- Catalog/inventory management operations for admins: CRUD on products and
variants, stock adjustment, featured/one-of-a-kind flags, restricted to
the admin role (FR-30–FR-33).

## 4. Data model

- **Product** — id, name, description, category, collection/tags, careInfo,
dimensions, images\[\], basePrice, isOneOfAKind, isFeatured, status
(active/retired).
- **Variant** — id, productId, name (e.g. glaze color/size), priceOverride,
stockCount, sku.
- **Cart** — id, ownerType (guest-session | account), ownerRef, items\[\]
(variantId, quantity, priceSnapshot), updatedAt.
- **Order** — id, orderNumber, customerEmail, customerId (nullable, for
guests), shippingAddress, items\[\] (variantId, name, quantity, unitPrice),
subtotal, shippingFee, tax, total, paymentStatus, fulfillmentStatus,
trackingNumber, statusHistory\[\], createdAt.
- **Account** — id (maps to Thunder subject), email, savedAddresses\[\].
- **Address** — id, accountId, line1, line2, city, region, postalCode,
country, phone.

Relationships: Product 1—N Variant; Cart 1—N CartItem (→ Variant); Order 1—N
OrderItem (→ Variant snapshot); Account 1—N Address; Account 1—N Order.

## 5. Roles &amp; access

## 6. Interactions

- `ceramics-webapp` → `ceramics-api`: catalog, cart, checkout, account/order
history calls.
- `ceramics-webapp` → `user-auth` (Thunder): OIDC sign-in for optional
shopper accounts.
- `ceramics-admin-webapp` → `ceramics-api`: catalog/inventory and order
management calls.
- `ceramics-admin-webapp` → `user-auth` (Thunder): OIDC sign-in for staff,
whose admin role is carried in the `groups` claim.
- `ceramics-api` → `ceramics-db`: all persistence.
- `ceramics-api` → `user-auth` (Thunder): validates bearer tokens via the
platform gateway (JWT validation is gateway-side; the API reads the
injected identity/role headers).
- `ceramics-api` → `payment-provider` (Stripe): payment intent creation and
confirmation during checkout.
- `ceramics-api` → `email-provider`: order confirmation and shipment
notification emails.

## 7. Data flow

1. **Browse &amp; add to cart**: shopper (guest or signed in) requests the
 catalog from `ceramics-webapp`, which calls `ceramics-api`; adding an item
 creates/updates a cart row keyed by session or account, validated against
 `Variant.stockCount`.
2. **Checkout**: shopper submits shipping/contact + card details;
 `ceramics-api` re-validates stock and price, computes shipping fee and
 tax, creates a Stripe payment intent, and on confirmed payment creates the
 `Order`, decrements `Variant.stockCount` (delisting one-of-a-kind items),
 and asks `email-provider` to send a confirmation.
3. **Order fulfillment**: an admin, signed in via `ceramics-admin-webapp`,
 reviews orders, updates fulfillment status and tracking number in
 `ceramics-api`, which persists the change and triggers a shopper
 notification email; a refund/cancel similarly updates status and restores
 stock when applicable.
4. **Account history**: a signed-in shopper's `ceramics-webapp` session
 fetches their past orders and saved addresses from `ceramics-api`,
 scoped to their Thunder identity (`X-User-Id`).