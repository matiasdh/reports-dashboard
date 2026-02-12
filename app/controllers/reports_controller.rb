class ReportsController < ApplicationController
  def index
    @reports = Report.includes(:user).order(created_at: :desc)
  end

  def create
    report = Report.create!(report_params)
    GenerateReportJob.perform_later(report.id)
    redirect_to reports_path, notice: "Report queued successfully."
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :report_type)
  end
end
