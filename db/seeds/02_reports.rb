Faker::Config.random = Random.new(43)

report_types = Report.report_types.keys
records = []
index = 0

User.find_each do |user|
  report_types.each do |type|
    date_time = Faker::Time.between(
      from: Date.new(2026, 1, 1).to_time,
      to: Date.new(2026, 1, 31).to_time
    )
    date_str = date_time.utc.to_date.strftime("%Y%m%d")
    code = "#{type.upcase}-#{date_str}-#{user.id}"
    # 1 failed every 5 reports, rest pending
    status = (index % 5 == 4) ? Report.statuses[:failed] : Report.statuses[:pending]

    records << {
      user_id: user.id,
      code: code,
      status: status,
      report_type: Report.report_types[type],
      created_at: date_time,
      updated_at: date_time
    }
    index += 1
  end
end

Report.upsert_all(records, unique_by: :index_reports_on_code)

# Enqueue pending reports for background PDF generation (Sidekiq processes when running `just dev`)
enqueued_count = 0
Report.where(status: :pending).find_each do |report|
  ReportGeneratorJob.perform_later(report)
  enqueued_count += 1
end

puts "Seeded #{Report.count} reports (#{enqueued_count} enqueued for PDF generation)"
