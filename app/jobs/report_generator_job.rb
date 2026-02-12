class ReportGeneratorJob < ApplicationJob
  queue_as :default

  def perform(report)
    GenerateReportService.new(report: report).call
  end
end
