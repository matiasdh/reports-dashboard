require "rails_helper"

RSpec.describe GenerateReportJob, type: :job do
  let(:report) { create(:report, :pending, report_type: :daily_sales) }

  describe "#perform" do
    it "calls GenerateReportService with the report" do
      allow(GenerateReportService).to receive(:call).with(report).and_return(report)

      described_class.new.perform(report.id)

      expect(GenerateReportService).to have_received(:call).with(report)
    end

    it "fetches and stores report data" do
      allow(ReportsGateway).to receive(:fetch_report).with("daily_sales").and_return({ date: "2026-01-15", sold_items: [], total_sales_cents: 0 })

      described_class.new.perform(report.id)

      expect(report.reload).to be_completed
      expect(report.result_data).to be_present
    end
  end
end
