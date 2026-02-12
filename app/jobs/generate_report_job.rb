class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(report_id)
    report = Report.find(report_id)
    GenerateReportService.call(report)
  end
end
