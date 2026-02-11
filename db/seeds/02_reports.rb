now = Time.current
today = Date.current
users = User.all

report_types = Report.report_types.keys

records = users.flat_map do |user|
  report_types.map do |type|
    code = "#{type.upcase}-#{today.strftime('%Y%m%d')}-#{user.id}"
    {
      user_id: user.id,
      code: code,
      status: Report.statuses.values.sample,
      report_type: Report.report_types[type],
      created_at: now,
      updated_at: now
    }
  end
end

Report.upsert_all(records, unique_by: :index_reports_on_code)

puts "Seeded #{Report.count} reports"
