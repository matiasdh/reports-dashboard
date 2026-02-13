require "rails_helper"

RSpec.describe ReportGeneratorJob do
  include ActiveJob::TestHelper

  around do |example|
    original_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :test
    example.run
  ensure
    ActiveJob::Base.queue_adapter = original_adapter
  end

  let(:report) { create(:report, status: :pending) }

  it "enqueues the job" do
    expect {
      described_class.perform_later(report)
    }.to have_enqueued_job(described_class).with(report)
  end

  it "calls GenerateReportService when performed" do
    result = GenerateReportService::Result.success(report)
    service = instance_double(GenerateReportService, call: result)
    allow(GenerateReportService).to receive(:new).with(report: report).and_return(service)

    described_class.perform_now(report)

    expect(service).to have_received(:call)
  end

  it "catches StandardError and schedules retry instead of raising immediately" do
    allow(GenerateReportService).to receive(:new).and_return(
      instance_double(GenerateReportService, call: -> { raise StandardError, "Transient failure" })
    )

    expect { described_class.perform_now(report) }.not_to raise_error
  end

  it "discards on ActiveRecord::RecordNotFound when report was deleted" do
    report = create(:report, status: :pending)
    Report.destroy(report.id)

    expect { described_class.perform_now(report) }.not_to raise_error
  end

  it "discards on ActiveJob::DeserializationError when report was deleted before job ran" do
    report = create(:report, status: :pending)
    described_class.perform_later(report)
    Report.destroy(report.id)

    expect { perform_enqueued_jobs }.not_to raise_error
  end
end
