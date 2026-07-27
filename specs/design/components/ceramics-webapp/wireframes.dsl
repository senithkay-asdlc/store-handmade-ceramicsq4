// Ceramics Storefront — public shopper flow, desktop

screen Catalog "Shopper browses and searches the ceramics catalog"
  navbar "Ceramica | Shop | Collections | About | Cart (3)"
  row
    heading "Handmade Ceramics"
    right
    search "Search mugs, bowls, vases…"
    select "Sort: Newest"
  row
    badge "All" info
    badge "Mugs"
    badge "Bowls"
    badge "Vases"
    badge "Plates"
  row
    card "Speckled Stoneware Mug | $28 | Glaze: Oatmeal · In stock" -> ProductDetail
    card "Indigo Drip Bowl | $42 | One-of-a-kind piece" -> ProductDetail
    card "Matte Ivory Vase | $65 | Sold out" -> ProductDetail
  row
    card "Sage Green Plate Set | $54 | 3 glaze colors" -> ProductDetail
    card "Charcoal Speckle Mug | $28 | Featured" -> ProductDetail
    card "Rustic Serving Bowl | $58 | 2 left" -> ProductDetail

screen ProductDetail "Shopper reviews a product and adds it to the cart"
  navbar "Ceramica | Shop | Collections | About | Cart (3)"
  breadcrumb "Shop / Mugs / Speckled Stoneware Mug"
  split 60/40
    left
      image "Product photo"
      row
        image "Thumb 1"
        image "Thumb 2"
        image "Thumb 3"
    right
      heading "Speckled Stoneware Mug"
      text "$28 — handthrown stoneware, food-safe glaze"
      badge "In stock" success
      select "Glaze: Oatmeal"
      select "Size: 12oz"
      text "Care: hand wash, microwave safe"
      row
        input "Quantity: 1"
        button "Add to cart" primary -> Cart

screen Cart "Shopper reviews cart items before checkout"
  navbar "Ceramica | Shop | Collections | About | Cart (3)"
  heading "Your Cart"
  table "Item | Glaze/Size | Qty | Price"
    row "Speckled Stoneware Mug | Oatmeal, 12oz | 1 | $28"
    row "Indigo Drip Bowl | One-of-a-kind | 1 | $42"
    row "Sage Green Plate Set | Sage | 1 | $54"
  row
    right
    text "Subtotal: $124.00"
  row
    right
    button "Continue shopping"
    button "Checkout" primary -> Checkout

screen Checkout "Shopper enters shipping and payment details, as guest or signed in"
  navbar "Ceramica | Shop | Collections | About | Cart (3)"
  heading "Checkout"
  split 60/40
    left
      heading "Contact & shipping"
      input "Email address"
      input "Phone (optional)"
      input "Address line 1"
      input "City"
      row
        input "State/Region"
        input "Postal code"
      checkbox "Create an account to save my details"
      heading "Payment"
      input "Card number"
      row
        input "Expiry"
        input "CVC"
    right
      card "Order summary"
        text "Subtotal: $124.00"
        text "Shipping: $6.00"
        text "Tax: $9.75"
        text "Total: $139.75"
      button "Place order" primary -> OrderConfirmation

screen OrderConfirmation "Shopper sees confirmation after a successful payment"
  navbar "Ceramica | Shop | Collections | About | Cart (0)"
  heading "Thank you — order placed!"
  text "Order #CER-10482 — a confirmation email is on its way."
  card "Delivery estimate | 5-7 business days | Flat-rate shipping"
  button "View order history" -> OrderHistory
  button "Continue shopping" primary -> Catalog

screen OrderHistory "Signed-in shopper reviews their past orders"
  navbar "Ceramica | Shop | Collections | About | Cart (0)"
  heading "Your Orders"
  table "Order | Date | Status | Total"
    row "CER-10482 | Jul 20, 2026 | Shipped | $139.75"
    row "CER-10311 | Jun 2, 2026 | Delivered | $86.50"
    row "CER-10004 | Mar 14, 2026 | Delivered | $42.00"
  heading "Saved addresses"
  card "Home | 221B Kiln Street, Portland, OR 97201"
  button "Add address"
