Faker::Config.random = Random.new(43)

report_types = Report.report_types.keys
records = []

User.find_each do |user|
  report_types.each do |type|
    date_time = Faker::Time.between(
      from: Date.new(2026, 1, 1).to_time,
      to: Date.new(2026, 1, 31).to_time
    )
    date_str = date_time.utc.to_date.strftime("%Y%m%d")
    code = "#{type.upcase}-#{date_str}-#{user.id}"

    records << {
      user_id: user.id,
      code: code,
      status: Report.statuses.values.sample,
      report_type: Report.report_types[type],
      created_at: date_time,
      updated_at: date_time
    }
  end
end

Report.upsert_all(records, unique_by: :index_reports_on_code)

puts "Seeded #{Report.count} reports"
