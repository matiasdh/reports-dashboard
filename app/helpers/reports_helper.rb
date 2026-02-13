module ReportsHelper
  def format_numeric_html(value, symbol:, precision: nil)
    formatted = precision ? number_with_precision(value, precision: precision, delimiter: ",", separator: ".") : number_with_delimiter(value)
    tag.span(class: "formatted-numeric") do
      safe_join([ tag.span(symbol, class: "numeric-symbol"), tag.span(formatted, class: "numeric-value") ], " ")
    end
  end

  def format_currency_html(cents)
    format_numeric_html((cents / 100.0).round(2), symbol: "$", precision: 2)
  end

  def format_quantity_html(quantity)
    format_numeric_html(quantity.to_i, symbol: "#")
  end

  def report_type_label(report)
    report.report_type.titleize
  end

  def report_formatted_created_at(report)
    report.created_at.strftime("%b %d, %Y %H:%M")
  end

  def status_badge_class(status)
    base = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium"
    case status&.to_s
    when "completed" then "#{base} bg-emerald-100 text-emerald-700"
    when "failed" then "#{base} bg-rose-100 text-rose-700"
    when "processing" then "#{base} bg-sky-100 text-sky-700"
    else "#{base} bg-slate-100 text-slate-600"
    end
  end

  def status_badge_html(report)
    render "reports/status_badge", report: report
  end

  def form_select_input_classes
    "block w-full rounded-lg border-slate-300 bg-white px-3 py-3 text-sm text-slate-900 shadow-sm ring-1 ring-slate-900/5 focus:border-slate-400 focus:ring-2 focus:ring-slate-400/20"
  end

  def table_header_classes(align: "left")
    base = "px-4 py-2 sm:px-6 sm:py-2.5 text-xs font-semibold text-slate-500 uppercase tracking-wider"
    align_class = align == "right" ? "text-right" : "text-left"
    "#{base} #{align_class}"
  end
end
