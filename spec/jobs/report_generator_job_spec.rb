require "rails_helper"

RSpec.describe ReportGeneratorJob do
  let(:report) { create(:report, status: :pending) }

  it "enqueues the job" do
    expect {
      described_class.perform_later(report)
    }.to have_enqueued_job(described_class).with(report)
  end

  it "calls GenerateReportService when performed" do
    result = ReportServiceResult.success(report)
    service = instance_double(GenerateReportService, call: result)
    allow(GenerateReportService).to receive(:new).with(report: report).and_return(service)

    described_class.perform_now(report)

    expect(service).to have_received(:call)
  end
end
