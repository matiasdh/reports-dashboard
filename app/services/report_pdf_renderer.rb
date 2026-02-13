class ReportPdfRenderer
  def initialize(report)
    @report = report
  end

  def call
    ApplicationController.render(
      template: "reports/pdf",
      layout: "pdf",
      assigns: {
        report: report,
        data: report.result_data || raise(ArgumentError, "result_data cannot be nil")
      }
    )
  end

  private

  attr_reader :report
end
