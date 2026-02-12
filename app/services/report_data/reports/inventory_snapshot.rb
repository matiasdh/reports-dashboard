class ReportData::Reports::InventorySnapshot
  def fetch
    skus = Array.new(Faker::Number.between(from: 10, to: 25)) do
      quantity = Faker::Number.between(from: 0, to: 200)
      unit_price_cents = Faker::Number.between(from: 100, to: 9999)
      status = quantity.zero? ? "out_of_stock" : (quantity < 10 ? "low_stock" : "in_stock")
      value_cents = quantity * unit_price_cents

      {
        sku: Faker::Alphanumeric.alphanumeric(number: 10),
        product: Faker::Commerce.product_name,
        quantity: quantity,
        unit_price_cents: unit_price_cents,
        value_cents: value_cents,
        status: status
      }
    end

    {
      snapshot_at: Time.current.iso8601,
      skus: skus,
      total_sku_count: skus.size,
      total_inventory_value_cents: skus.sum { |s| s[:value_cents] },
      low_stock_count: skus.count { |s| s[:status] == "low_stock" },
      out_of_stock_count: skus.count { |s| s[:status] == "out_of_stock" }
    }
  end
end
