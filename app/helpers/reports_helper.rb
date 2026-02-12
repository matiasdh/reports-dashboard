module ReportsHelper
  def report_type_label(report)
    report.report_type.titleize
  end

  def report_formatted_created_at(report)
    report.created_at.strftime("%b %d, %Y %H:%M")
  end

  def status_badge_class(status)
    base = "inline-flex rounded-full px-2.5 py-0.5 text-xs font-medium"
    case status&.to_sym
    when :completed then "#{base} bg-emerald-100 text-emerald-700"
    when :failed then "#{base} bg-rose-100 text-rose-700"
    when :processing, :fetching_data then "#{base} bg-sky-100 text-sky-700"
    else "#{base} bg-slate-100 text-slate-600"
    end
  end
end
