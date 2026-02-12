class GenerateReportService < BaseService
  def initialize(report)
    @report = report
  end

  def call
    data = fetch_data!
    save_result!(data)
    @report
  rescue => e
    mark_failed!(e)
    raise
  end

  private

  def fetch_data!
    @report.fetching_data!
    ReportsGateway.fetch_report(@report.report_type)
  end

  def save_result!(data)
    @report.processing!
    @report.update!(result_data: data.to_json, status: :completed)
  end

  def mark_failed!(error)
    @report.update!(status: :failed, result_data: { error: error.message }.to_json)
  end
end
