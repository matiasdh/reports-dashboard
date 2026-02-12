class ReportsGateway
  def self.fetch_report(report_type)
    ReportData::Reports.fetch(report_type)
  end
end
