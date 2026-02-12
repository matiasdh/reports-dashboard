class Report < ApplicationRecord
  belongs_to :user
  has_one_attached :pdf

  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }
  enum :report_type, { daily_sales: 0, monthly_summary: 1, inventory_snapshot: 2 }

  validates :code, presence: true, uniqueness: { message: "a report of this type has already been generated today" }
  validates :status, presence: true
  validates :report_type, presence: true

  before_validation :generate_code, on: :create, if: :new_record?

  def downloadable?
    completed? && pdf.attached?
  end

  def download_filename
    "#{code}.pdf"
  end

  private

  def generate_code
    return if user_id.blank? || report_type.blank?

    date_str = Date.current.strftime("%Y%m%d")
    self.code ||= "#{report_type.upcase}-#{date_str}-#{user_id}"
  end
end
