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
        data: JSON.parse(report.result_data)
      }
    )
  end

  private

  attr_reader :report
end
