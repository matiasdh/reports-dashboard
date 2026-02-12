require "ostruct"

class GenerateReportService
  def initialize(report:)
    @report = report
  end

  def call
    report.processing!
    broadcast_report_update!
    fetch_data!
    generate_pdf!
    mark_completed!
    broadcast_report_update!
    success
  rescue StandardError => e
    mark_failed!(e)
    broadcast_report_update!
    failure(e)
  end

  private

  attr_reader :report

  def fetch_data!
    data = ReportData::Reports.fetch(report.report_type)
    report.update!(result_data: data.to_json)
  end

  def generate_pdf!
    report.pdf.attach(
      io: StringIO.new(pdf_content),
      filename: report.download_filename,
      content_type: "application/pdf"
    )
  end

  def pdf_content
    Grover.new(ReportPdfRenderer.new(report).call).to_pdf
  end

  def mark_completed!
    report.completed!
  end

  def mark_failed!(error)
    report.failed!
    Rails.logger.error("Report #{report.id} failed: #{error.message}")
  end

  def success
    OpenStruct.new(success?: true, report: report)
  end

  def failure(error)
    OpenStruct.new(success?: false, report: report, error: error)
  end

  def broadcast_report_update!
    Turbo::StreamsChannel.broadcast_replace_to(
      "reports",
      target: report,
      partial: "reports/report_row",
      locals: { report: report }
    )
  end
end
