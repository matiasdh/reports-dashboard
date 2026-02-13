require "rails_helper"

RSpec.describe ReportPdfRenderer do
  let(:user) { create(:user) }

  describe "#call" do
    it "renders the PDF template with parsed result_data" do
      report = create(:report, :completed, user: user, report_type: :daily_sales)
      report.update!(result_data: { date: "2026-02-12", sold_items: [], total_sales_cents: 0 })

      html = described_class.new(report).call

      expect(html).to include("Daily Sales")
      expect(html).to include(report.code)
      expect(html).to include(user.name)
    end

    it "raises when result_data is nil" do
      report = create(:report, user: user, report_type: :daily_sales, result_data: nil)

      expect { described_class.new(report).call }.to raise_error(ArgumentError, "result_data cannot be nil")
    end
  end
end
