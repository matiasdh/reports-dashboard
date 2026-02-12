require "rails_helper"

RSpec.describe ReportData::Reports do
  describe ".fetch" do
    it "returns data for valid report type" do
      data = described_class.fetch(:daily_sales)

      expect(data).to be_a(Hash)
      expect(data).not_to be_empty
    end

    it "raises for invalid report type" do
      expect {
        described_class.fetch(:invalid_type)
      }.to raise_error(ArgumentError, /Unknown report type/)
    end

    it "calls daily_sales fetcher for daily_sales" do
      instance = instance_double(ReportData::Reports::DailySales, fetch: {})
      allow(ReportData::Reports::DailySales).to receive(:new).and_return(instance)

      described_class.fetch(:daily_sales)

      expect(ReportData::Reports::DailySales).to have_received(:new)
      expect(instance).to have_received(:fetch)
    end

    it "calls monthly_summary fetcher for monthly_summary" do
      instance = instance_double(ReportData::Reports::MonthlySummary, fetch: {})
      allow(ReportData::Reports::MonthlySummary).to receive(:new).and_return(instance)

      described_class.fetch(:monthly_summary)

      expect(ReportData::Reports::MonthlySummary).to have_received(:new)
      expect(instance).to have_received(:fetch)
    end

    it "calls inventory_snapshot fetcher for inventory_snapshot" do
      instance = instance_double(ReportData::Reports::InventorySnapshot, fetch: {})
      allow(ReportData::Reports::InventorySnapshot).to receive(:new).and_return(instance)

      described_class.fetch(:inventory_snapshot)

      expect(ReportData::Reports::InventorySnapshot).to have_received(:new)
      expect(instance).to have_received(:fetch)
    end
  end
end
