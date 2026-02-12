require "rails_helper"

RSpec.describe ReportsGateway do
  it "delegates to ReportData::Reports.fetch" do
    data = { date: "2026-01-15", sold_items: [] }
    allow(ReportData::Reports).to receive(:fetch).with(:daily_sales).and_return(data)

    result = described_class.fetch_report(:daily_sales)

    expect(ReportData::Reports).to have_received(:fetch).with(:daily_sales)
    expect(result).to eq(data)
  end
end
