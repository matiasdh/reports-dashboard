Faker::Config.random = Random.new(43)

report_types = Report.report_types.keys
statuses = Report.statuses.values
records = []
first_user_id = User.minimum(:id)

User.find_each do |user|
  report_types.each do |type|
    date_time = Faker::Time.between(
      from: Date.new(2026, 1, 1).to_time,
      to: Date.new(2026, 1, 31).to_time
    )
    date_str = date_time.utc.to_date.strftime("%Y%m%d")
    code = "#{type.upcase}-#{date_str}-#{user.id}"
    # First user gets one completed report per type (for PDF testing); others cycle through statuses
    type_index = report_types.index(type)
    status = (user.id == first_user_id) ?
      Report.statuses[:completed] :
      statuses[(user.id + type_index) % statuses.size]

    records << {
      user_id: user.id,
      code: code,
      status: status,
      report_type: Report.report_types[type],
      created_at: date_time,
      updated_at: date_time
    }
  end
end

Report.upsert_all(records, unique_by: :index_reports_on_code)

# Generate PDFs for completed reports (requires Chrome via GROVER_CHROME_WS_URL, e.g. ws://localhost:3001)
completed_count = 0
Report.where.not(status: :failed).find_each do |report|
  next if report.pdf.attached?

  result = GenerateReportService.new(report: report).call
  if result.success?
    completed_count += 1
  else
    report.completed! # Restore status if PDF generation failed (e.g. Chrome not running)
  end
end

puts "Seeded #{Report.count} reports (#{completed_count} PDFs generated)"
