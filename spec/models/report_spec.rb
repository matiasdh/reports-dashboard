require "rails_helper"

RSpec.describe Report, type: :model do
  describe "factory" do
    it "has a valid factory" do
      report = build(:report, user: build_stubbed(:user))
      expect(report).to be_valid
    end

    it "has valid traits" do
      user = build_stubbed(:user)
      expect(build(:report, :processing, user: user, report_type: :daily_sales)).to be_valid
      expect(build(:report, :completed, user: user, report_type: :monthly_summary)).to be_valid
      expect(build(:report, :failed, user: user, report_type: :inventory_snapshot)).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:status)
        .with_values(pending: 0, processing: 1, completed: 2, failed: 3)
    }

    it {
      is_expected.to define_enum_for(:report_type)
        .with_values(daily_sales: 0, monthly_summary: 1, inventory_snapshot: 2)
    }
  end

  describe "validations" do
    subject { build(:report, user: build_stubbed(:user)) }

    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:report_type) }

    it "validates uniqueness of code" do
      existing = create(:report)
      duplicate = build(:report, code: existing.code)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:code]).to include("a report of this type has already been generated today")
    end
  end

  describe "code generation" do
    it "auto-generates code on validate" do
      user = build_stubbed(:user)
      report = build(:report, user: user, report_type: :daily_sales)
      report.valid?

      expected_code = "DAILY_SALES-#{Date.current.strftime('%Y%m%d')}-#{user.id}"
      expect(report.code).to eq(expected_code)
    end

    it "generates different codes for different report types" do
      user = build_stubbed(:user)
      report_a = build(:report, user: user, report_type: :daily_sales)
      report_b = build(:report, user: user, report_type: :monthly_summary)
      report_a.valid?
      report_b.valid?

      expect(report_a.code).not_to eq(report_b.code)
    end
  end

  describe "uniqueness per user, type, and day" do
    it "prevents duplicate reports of the same type for the same user on the same day" do
      user = create(:user)
      create(:report, user: user, report_type: :daily_sales)

      duplicate = build(:report, user: user, report_type: :daily_sales)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:code]).to include("a report of this type has already been generated today")
    end

    it "allows the same report type for different users" do
      create(:report, report_type: :daily_sales)

      other_user = create(:user)
      report_b = build(:report, user: other_user, report_type: :daily_sales)
      expect(report_b).to be_valid
    end

    it "allows different report types for the same user on the same day" do
      user = create(:user)
      create(:report, user: user, report_type: :daily_sales)

      different_type = build(:report, user: user, report_type: :monthly_summary)
      expect(different_type).to be_valid
    end
  end
end
