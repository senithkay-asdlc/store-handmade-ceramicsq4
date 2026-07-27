# Requirements Specification: Handmade Ceramics Online Store

## 1. Overview

An online store for a single handmade-ceramics business (B2C retail) that lets
shoppers browse a product catalog, add items to a cart, and complete checkout
with real payment processing. An admin console allows staff to manage the
catalog and fulfill orders.

### 1.1 Scope Assumptions (confirmed with stakeholder)

- **Audience**: Public consumers only. No wholesale tier, no multi-vendor
marketplace — this is a single seller's storefront.
- **Accounts**: Optional. Shoppers may check out as a guest or register for an
account that retains order history and saved details. An account is never
required to complete a purchase.
- **Payments**: Real payment processing via a third-party payment gateway
(e.g., Stripe). No simulated/mock payments in production.
- **Inventory**: Each product (and each of its variants, e.g. glaze color or
size) carries a simple on-hand stock count. When a variant's count reaches
zero it is marked sold out and cannot be added to the cart.
- **Administration**: A back-office admin console is in scope for catalog
management (create/edit/retire products, adjust stock) and order management
(view orders, update fulfillment/shipment status).
- **Shipping**: Single flat-rate shipping cost (or free-shipping threshold);
no live carrier-rate API integration. Fulfillment status is updated manually
by staff.

## 2. Actors

## 3. Functional Requirements

### 3.1 Product Catalog

- FR-1: The system shall display a list of ceramic products with name,
representative image, price, and short description.
- FR-2: The system shall allow browsing products by category (e.g., mugs,
bowls, vases, plates, decorative) and by collection/tag.
- FR-3: The system shall provide a product detail page showing full
description, materials/care instructions, dimensions, multiple images,
price, available variants (e.g., glaze color, size), and stock status.
- FR-4: The system shall support full-text search over product name and
description.
- FR-5: The system shall allow sorting/filtering results (e.g., by price,
newest, category).
- FR-6: The system shall mark a product or variant as "Sold Out" when its
stock count is zero and shall prevent adding sold-out items to the cart.
- FR-7: Because items are handmade, the system shall support marking a
product as a one-of-a-kind piece that is automatically delisted from the
catalog once purchased.

### 3.2 Shopping Cart

- FR-8: The system shall allow a shopper to add a product (with selected
variant) and quantity to a cart.
- FR-9: The system shall allow a shopper to view, update quantities in, and
remove items from the cart.
- FR-10: The system shall persist the cart for a guest across pages within
the same session/browser, and persist it to the shopper's account when
signed in so it survives across devices/sessions.
- FR-11: The system shall prevent the cart from holding more units of a
variant than are currently in stock, re-validating stock at checkout time.
- FR-12: The system shall display a running subtotal (before shipping and
tax) as the cart changes.

### 3.3 Checkout

- FR-13: The system shall allow checkout as a guest (providing contact,
shipping, and payment details) or, if signed in, using saved details.
- FR-14: The system shall collect a shipping address, contact email, and
(optionally) phone number.
- FR-15: The system shall apply a flat-rate shipping fee based on
configurable rules (e.g., flat fee, or free above an order-total
threshold); no real-time carrier rate lookup is required.
- FR-16: The system shall calculate and display applicable sales tax based
on the shipping destination.
- FR-17: The system shall process payment through a third-party payment
gateway supporting major credit/debit cards.
- FR-18: The system shall re-validate stock availability and current prices
immediately before charging payment, and shall reject/adjust the order if
an item became unavailable.
- FR-19: On successful payment, the system shall create an order record,
decrement stock for each purchased variant, and display an order
confirmation with an order number.
- FR-20: The system shall send an order confirmation email to the shopper
after successful checkout.
- FR-21: If payment fails, the system shall show a clear error and leave the
cart intact so the shopper can retry.

### 3.4 Shopper Accounts

- FR-22: The system shall allow a shopper to register an account with email
and password (or equivalent), and to sign in/out.
- FR-23: A signed-in shopper shall be able to view their past orders and each
order's status.
- FR-24: A signed-in shopper shall be able to save one or more shipping
addresses for reuse at checkout.
- FR-25: Guest checkout shall never require account creation and shall
optionally offer to create an account from the details already entered.

### 3.5 Order Management (Admin)

- FR-26: The system shall let an admin view a list of orders with filtering
by status (e.g., Placed, Paid, Shipped, Delivered, Canceled/Refunded).
- FR-27: The system shall let an admin view full order detail: items,
customer/shipping info, payment status, and history of status changes.
- FR-28: The system shall let an admin update an order's fulfillment status
and optionally attach a shipment tracking number, triggering a shopper
notification email.
- FR-29: The system shall let an admin issue a refund or cancel an order,
reflecting this in order status and, where applicable, restoring stock.

### 3.6 Catalog &amp; Inventory Management (Admin)

- FR-30: The system shall let an admin create, edit, and retire (unpublish)
products, including name, description, category, images, price, and
variants.
- FR-31: The system shall let an admin set and adjust the stock count for
each product/variant.
- FR-32: The system shall let an admin mark a product as featured or as a
one-of-a-kind piece.
- FR-33: The system shall restrict catalog and order management actions to
authenticated admin users only.

## 4. Non-Functional Requirements

- NFR-1 (Availability): The storefront (browsing, cart, checkout) shall be
available and responsive during normal retail hours with no single point
of failure preventing checkout.
- NFR-2 (Security): Payment card data shall never be stored or handled
directly by the application; it shall be tokenized/processed entirely
through the payment gateway (PCI scope minimization).
- NFR-3 (Security): Admin functionality shall require authentication and
shall not be reachable by unauthenticated or non-admin users.
- NFR-4 (Data protection): Shopper personal data (contact info, addresses,
order history) shall be stored securely and transmitted only over
encrypted connections (TLS).
- NFR-5 (Performance): Catalog listing and product detail pages shall load
within 2 seconds under normal load.
- NFR-6 (Consistency): Stock decrements must be atomic/consistent so that
concurrent purchases cannot oversell a limited or one-of-a-kind item.
- NFR-7 (Usability): The storefront shall be usable on both desktop and
mobile browsers (responsive design).
- NFR-8 (Auditability): Changes to order status and stock adjustments made
by admins shall be recorded with a timestamp and the acting admin.

## 5. Out of Scope

- Wholesale/B2B pricing tiers and multi-vendor marketplace features.
- Real-time third-party shipping-carrier rate calculation and label
generation.
- Loyalty/rewards programs, gift cards, and coupon/promotion engines
(may be considered in a future phase).
- Multi-currency / international tax compliance beyond a single
destination-based sales tax calculation.

## 6. Success Criteria

The project is successful when a shopper can browse the ceramics catalog,
add in-stock items to a cart, complete checkout (as guest or registered
account) with a real card payment, receive an order confirmation, and an
admin can manage the catalog and fulfill/track that order end to end.