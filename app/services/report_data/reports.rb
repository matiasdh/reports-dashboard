module ReportData
  class Reports
    FETCHERS = {
      "daily_sales" => Reports::DailySales,
      "monthly_summary" => Reports::MonthlySummary,
      "inventory_snapshot" => Reports::InventorySnapshot
    }.freeze

    def self.fetch(report_type)
      fetcher = FETCHERS[report_type.to_s]
      raise ArgumentError, "Unknown report type: #{report_type}" unless fetcher

      fetcher.new.fetch
    end
  end
end
