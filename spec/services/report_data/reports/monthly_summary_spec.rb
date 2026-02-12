require "rails_helper"

RSpec.describe ReportData::Reports::MonthlySummary do
  describe "#fetch" do
    subject(:data) { described_class.new.fetch }

    it "returns month, orders, revenue, and orders_count" do
      expect(data).to include(:month, :orders, :revenue_cents, :orders_count)
      expect(data[:orders]).to be_an(Array)
      expect(data[:orders]).not_to be_empty
      expect(data[:orders].first).to include(:order_id, :date, :items, :amount_cents, :items_count)
    end
  end
end
