class ReportData::Reports::MonthlySummary
  def fetch
    orders = Array.new(Faker::Number.between(from: 10, to: 30)) do
      items = Array.new(Faker::Number.between(from: 1, to: 20)) do
        quantity = Faker::Number.between(from: 1, to: 10)
        unit_price_cents = Faker::Number.between(from: 100, to: 9999)
        {
          product: Faker::Commerce.product_name,
          quantity: quantity,
          unit_price_cents: unit_price_cents,
          total_cents: quantity * unit_price_cents
        }
      end
      amount_cents = items.sum { |i| i[:total_cents] }
      {
        order_id: Faker::Alphanumeric.alphanumeric(number: 8),
        date: Faker::Date.between(from: 1.month.ago, to: Date.current).iso8601,
        items: items,
        amount_cents: amount_cents,
        items_count: items.size
      }
    end

    {
      month: Date.current.strftime("%Y-%m"),
      orders: orders,
      revenue_cents: orders.sum { |o| o[:amount_cents] },
      orders_count: orders.size
    }
  end
end
