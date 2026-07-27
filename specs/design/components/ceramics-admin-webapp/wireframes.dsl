// Ceramics Admin Console — staff-only back office, desktop

screen OrderQueue "Admin monitors incoming orders and acts on what needs fulfillment"
  navbar "Ceramica Admin"
  sidebar "Orders | Products | Inventory | Settings"
  row
    heading "Orders"
    right
    search "Search order # or email"
    select "Status: All"
  row
    badge "All (146)" info
    badge "Placed (12)"
    badge "Paid (18)"
    badge "Shipped (94)"
    badge "Delivered (20)"
    badge "Canceled (2)"
  table "Order | Customer | Total | Status | Placed" -> OrderDetail
    row "CER-10482 | j.rivera@example.com | $139.75 | Paid | 2h ago"
    row "CER-10481 | s.kim@example.com | $56.00 | Shipped | 5h ago"
    row "CER-10480 | a.morris@example.com | $210.40 | Placed | 1d ago"

screen OrderDetail "Admin reviews one order and updates its fulfillment status"
  navbar "Ceramica Admin"
  sidebar "Orders | Products | Inventory | Settings"
  breadcrumb "Orders / CER-10482"
  row
    heading "Order CER-10482"
    badge "Paid" success
  text "j.rivera@example.com — placed Jul 25, 2026"
  split 60/40
    left
      heading "Items"
      table "Item | Qty | Price"
        row "Speckled Stoneware Mug (Oatmeal, 12oz) | 1 | $28"
        row "Indigo Drip Bowl (one-of-a-kind) | 1 | $42"
        row "Sage Green Plate Set (Sage) | 1 | $54"
      text "Subtotal $124.00 · Shipping $6.00 · Tax $9.75 · Total $139.75"
      heading "Shipping address"
      text "221B Kiln Street, Portland, OR 97201"
      row
        select "Fulfillment status: Paid"
        input "Tracking number"
        button "Update" primary
      row
        right
        button "Cancel / refund order" danger
    right
      heading "Status history"
      text "Jul 25, 10:02 — Order placed"
      text "Jul 25, 10:03 — Payment confirmed"

screen ProductList "Admin manages the catalog and stock levels"
  navbar "Ceramica Admin"
  sidebar "Orders | Products | Inventory | Settings"
  row
    heading "Products"
    right
    search "Search products"
    button "New product" primary -> ProductForm
  table "Product | Category | Price | Stock | Status" -> ProductForm
    row "Speckled Stoneware Mug | Mugs | $28 | 14 | Active"
    row "Indigo Drip Bowl | Bowls | $42 | 1 (one-of-a-kind) | Active"
    row "Matte Ivory Vase | Vases | $65 | 0 | Sold out"
    row "Winter Collection Plate | Plates | $54 | 8 | Retired"

screen ProductForm "Admin creates or edits a product, its variants, and stock"
  navbar "Ceramica Admin"
  sidebar "Orders | Products | Inventory | Settings"
  breadcrumb "Products / Speckled Stoneware Mug"
  heading "Edit Product"
  input "Name"
  textarea "Description"
  row
    select "Category: Mugs"
    select "Collection: Everyday"
  input "Base price"
  textarea "Care & dimensions"
  checkbox "One-of-a-kind piece"
  checkbox "Featured" active
  heading "Variants & stock"
  table "Variant | SKU | Price override | Stock"
    row "Oatmeal, 12oz | MUG-OAT-12 | — | 14"
    row "Slate, 12oz | MUG-SLT-12 | — | 6"
  button "Add variant"
  row
    right
    button "Retire product"
    button "Save changes" primary -> ProductList
