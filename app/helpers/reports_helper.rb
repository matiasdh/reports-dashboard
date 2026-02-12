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
    case status&.to_sym
    when :completed then "#{base} bg-emerald-100 text-emerald-700"
    when :failed then "#{base} bg-rose-100 text-rose-700"
    when :processing, :fetching_data then "#{base} bg-sky-100 text-sky-700"
    else "#{base} bg-slate-100 text-slate-600"
    end
  end

  def status_badge_html(report)
    status = report.status
    classes = status_badge_class(status)

    if status.to_sym == :processing
      content_tag(:span, class: classes) do
        spinner = content_tag(:svg, class: "animate-spin -ml-0.5 mr-1.5 size-3 text-sky-600", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24") do
          circle = content_tag(:circle, nil, class: "opacity-25", cx: "12", cy: "12", r: "10", stroke: "currentColor", "stroke-width": "4")
          path = content_tag(:path, nil, class: "opacity-75", fill: "currentColor", d: "M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z")
          safe_join([circle, path])
        end
        safe_join([spinner, status.humanize])
      end
    else
      content_tag(:span, status.humanize, class: classes)
    end
  end
end
