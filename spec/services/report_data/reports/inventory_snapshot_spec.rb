require "rails_helper"

RSpec.describe ReportData::Reports::InventorySnapshot do
  describe "#fetch" do
    subject(:data) { described_class.new.fetch }

    it "returns snapshot_at, skus, total_sku_count, total_inventory_value, and counts" do
      expect(data).to include(:snapshot_at, :skus, :total_sku_count, :total_inventory_value_cents,
                              :low_stock_count, :out_of_stock_count)
      expect(data[:skus]).to be_an(Array)
      expect(data[:skus]).not_to be_empty
      expect(data[:skus].first).to include(:sku, :product, :quantity, :unit_price_cents, :value_cents, :status)
    end
  end
end
