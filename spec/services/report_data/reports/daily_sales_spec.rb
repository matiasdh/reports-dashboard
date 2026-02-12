require "rails_helper"

RSpec.describe ReportData::Reports::DailySales do
  describe "#fetch" do
    subject(:data) { described_class.new.fetch }

    it "returns date, sold_items, and total_sales" do
      expect(data).to include(:date, :sold_items, :total_sales_cents)
      expect(data[:sold_items]).to be_an(Array)
      expect(data[:sold_items]).not_to be_empty
      expect(data[:sold_items].first).to include(:product, :quantity, :unit_price_cents, :total_cents)
      expect(data[:total_sales_cents]).to be_a(Integer)
    end
  end
end
