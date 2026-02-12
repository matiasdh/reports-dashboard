require "rails_helper"

RSpec.describe GenerateReportService do
  let(:report) { create(:report, status: :pending, report_type: :daily_sales) }
  let(:mock_data) { { "date" => "2026-02-12", "sold_items" => [], "total_sales_cents" => 0 } }

  before do
    allow(ReportData::Reports).to receive(:fetch).with(report.report_type).and_return(mock_data)
    allow_any_instance_of(Grover).to receive(:to_pdf).and_return("%PDF-1.4 mock")
  end

  it "fetches data and saves to result_data" do
    result = described_class.new(report: report).call

    expect(result.success?).to be true
    expect(report.reload.result_data).to be_present
    expect(JSON.parse(report.result_data)).to eq(mock_data)
  end

  it "generates PDF and attaches to report" do
    result = described_class.new(report: report).call

    expect(result.success?).to be true
    expect(report.reload.pdf.attached?).to be true
    expect(report.pdf.filename.to_s).to eq("#{report.code}.pdf")
    expect(report.pdf.content_type).to eq("application/pdf")
  end

  it "updates status to completed" do
    result = described_class.new(report: report).call

    expect(result.success?).to be true
    expect(report.reload.status).to eq("completed")
  end

  context "when fetch fails" do
    before do
      allow(ReportData::Reports).to receive(:fetch).and_raise(StandardError.new("Fetch failed"))
    end

    it "marks report as failed" do
      result = described_class.new(report: report).call

      expect(result.success?).to be false
      expect(report.reload.status).to eq("failed")
    end
  end

  describe "Turbo Stream broadcasts" do
    it "broadcasts report update when processing starts" do
      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(
        "reports",
        hash_including(target: report)
      ).at_least(:once)

      described_class.new(report: report).call
    end

    it "broadcasts report update when completed" do
      expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(
        "reports",
        hash_including(target: report)
      ).at_least(:once)

      described_class.new(report: report).call
    end

    context "when fetch fails" do
      before do
        allow(ReportData::Reports).to receive(:fetch).and_raise(StandardError.new("Fetch failed"))
      end

      it "broadcasts report update when failed" do
        expect(Turbo::StreamsChannel).to receive(:broadcast_replace_to).with(
          "reports",
          hash_including(target: report)
        ).at_least(:once)

        described_class.new(report: report).call
      end
    end
  end
end
