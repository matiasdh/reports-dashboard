module ApplicationHelper
  def flash_class(type)
    base = "mb-6 px-4 py-3 border rounded-lg text-sm"
    case type&.to_sym
    when :notice then "#{base} bg-emerald-50 border-emerald-200 text-emerald-800"
    when :alert then "#{base} bg-rose-50 border-rose-200 text-rose-800"
    else "#{base} bg-slate-50 border-slate-200 text-slate-800"
    end
  end
end
