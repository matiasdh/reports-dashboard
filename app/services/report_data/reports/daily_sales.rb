class ReportData::Reports::DailySales
  def fetch
    items = Array.new(Faker::Number.between(from: 5, to: 15)) do
      quantity = Faker::Number.between(from: 1, to: 50)
      unit_price_cents = Faker::Number.between(from: 100, to: 9999)
      {
        product: Faker::Commerce.product_name,
        quantity: quantity,
        unit_price_cents: unit_price_cents,
        total_cents: quantity * unit_price_cents
      }
    end

    {
      date: Date.current.iso8601,
      sold_items: items,
      total_sales_cents: items.sum { |i| i[:total_cents] }
    }
  end
end
