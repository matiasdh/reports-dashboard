require "rails_helper"

RSpec.describe ReportsHelper, type: :helper do
  describe "#format_currency_html" do
    it "returns $0.00 for nil" do
      expect(helper.format_currency_html(nil)).to include("0.00")
    end

    it "formats cents to dollars with 2 decimals" do
      expect(helper.format_currency_html(1299)).to include("12.99")
    end

    it "handles zero" do
      expect(helper.format_currency_html(0)).to include("0.00")
    end

    it "handles negative values" do
      expect(helper.format_currency_html(-100)).to include("-1.00")
    end
  end

  describe "#format_quantity_html" do
    it "returns zero for nil" do
      expect(helper.format_quantity_html(nil)).to include("0")
    end

    it "formats integer quantity" do
      expect(helper.format_quantity_html(42)).to include("42")
    end
  end

  describe "#status_badge_class" do
    it "returns default for nil" do
      expect(helper.status_badge_class(nil)).to include("bg-slate-100")
    end

    it "returns correct class for each status" do
      expect(helper.status_badge_class("completed")).to include("bg-emerald-100")
      expect(helper.status_badge_class("failed")).to include("bg-rose-100")
      expect(helper.status_badge_class("processing")).to include("bg-sky-100")
    end
  end
end
