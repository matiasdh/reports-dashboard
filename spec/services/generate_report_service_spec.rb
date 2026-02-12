require "rails_helper"

RSpec.describe GenerateReportService do
  let(:report) { create(:report, :pending, report_type: :daily_sales) }

  describe ".call" do
    it "fetches data via ReportsGateway and stores result" do
      data = { date: "2026-01-15", sold_items: [], total_sales_cents: 0 }
      allow(ReportsGateway).to receive(:fetch_report).with("daily_sales").and_return(data)

      result = described_class.call(report)

      expect(ReportsGateway).to have_received(:fetch_report).with("daily_sales")
      expect(report.reload).to be_completed
      expect(report.result_data).to eq(data.to_json)
      expect(result).to eq(report)
    end

    it "sets report to fetching_data during fetch" do
      allow(ReportsGateway).to receive(:fetch_report) do
        expect(report.reload).to be_fetching_data
        {}
      end

      described_class.call(report)
    end

    it "marks report as failed and re-raises on error" do
      allow(ReportsGateway).to receive(:fetch_report).and_raise(StandardError, "Gateway error")

      expect {
        described_class.call(report)
      }.to raise_error(StandardError, "Gateway error")

      expect(report.reload).to be_failed
      expect(JSON.parse(report.result_data)["error"]).to eq("Gateway error")
    end
  end
end
