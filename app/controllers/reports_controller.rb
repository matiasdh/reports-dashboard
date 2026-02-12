class ReportsController < ApplicationController
  def index
    @reports = Report.includes(:user).order(created_at: :desc)
    @report = Report.new(user_id: params[:user_id], report_type: params[:report_type])
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      flash[:notice] = "Report queued successfully."
    else
      flash[:alert] = @report.errors.full_messages.to_sentence
    end

    respond_to do |format|
      format.turbo_stream { render :create_failed, status: :unprocessable_entity unless @report.persisted? }
      format.html { redirect_to reports_path(user_id: @report.user_id, report_type: @report.report_type) }
    end
  end

  private

  def report_params
    params.require(:report).permit(:user_id, :report_type)
  end
end
