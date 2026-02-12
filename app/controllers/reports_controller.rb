class ReportsController < ApplicationController
  def index
    @pagy, @reports = pagy(:countish, Report.includes(:user).order(created_at: :desc))
    @report = Report.new(user_id: params[:user_id], report_type: params[:report_type])
  end

  def download
    @report = Report.find(params[:id])
    return head :not_found unless @report.downloadable?

    redirect_to rails_blob_url(
      @report.pdf,
      disposition: "attachment",
      filename: @report.download_filename
    ), allow_other_host: true
  end

  def create
    @report = Report.new(report_params)

    if @report.save
      ReportGeneratorJob.perform_later(@report)
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
