require "rails_helper"

RSpec.describe User, type: :model do
  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:reports).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    context "with invalid email format" do
      let(:user) { build(:user, email: "not-an-email") }

      it "rejects" do
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    context "with valid email format" do
      let(:user) { build(:user, email: "user@example.com") }

      it "accepts" do
        expect(user).to be_valid
      end
    end
  end
end
