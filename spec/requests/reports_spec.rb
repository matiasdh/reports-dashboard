require "rails_helper"

RSpec.describe "Reports", type: :request do
  describe "GET /reports" do
    it "returns a successful response" do
      get reports_path
      expect(response).to have_http_status(:ok)
    end

    it "displays reports ordered by newest first" do
      user = create(:user)
      older = create(:report, user: user, report_type: :daily_sales)
      newer = create(:report, user: user, report_type: :monthly_summary)

      get reports_path

      expect(response.body).to include(older.code)
      expect(response.body).to include(newer.code)
      expect(response.body).to include(ERB::Util.html_escape(user.name))
      # Newest first: newer appears before older in the rendered body
      expect(response.body.index(newer.code)).to be < response.body.index(older.code)
    end
  end

  describe "POST /reports" do
    let(:user) { create(:user) }

    it "creates a report and redirects with a notice" do
      expect {
        post reports_path, params: { report: { user_id: user.id, report_type: "daily_sales" } }
      }.to change(Report, :count).by(1)

      expect(response).to redirect_to(reports_path)
      follow_redirect!
      expect(response.body).to include("Report queued successfully.")
    end

    it "enqueues GenerateReportJob" do
      expect {
        post reports_path, params: { report: { user_id: user.id, report_type: "daily_sales" } }
      }.to have_enqueued_job(GenerateReportJob)
    end

    it "redirects with an alert for duplicate user + type + day" do
      create(:report, user: user, report_type: :daily_sales)

      post reports_path, params: { report: { user_id: user.id, report_type: "daily_sales" } }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("already been generated today")
    end

    it "redirects with an alert for missing report type" do
      post reports_path, params: { report: { user_id: user.id } }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Report type")
    end

    it "redirects with an alert for invalid user" do
      post reports_path, params: { report: { user_id: 0, report_type: "daily_sales" } }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("User must exist")
    end
  end
end
