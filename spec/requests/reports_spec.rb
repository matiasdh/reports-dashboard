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

      expect(response.body).to include("Daily Sales")
      expect(response.body).to include("Monthly Summary")
      expect(response.body).to include(ERB::Util.html_escape(user.name))
      # Newest first: within table body, Monthly Summary appears before Daily Sales
      tbody = response.body[/<tbody[^>]*>(.*?)<\/tbody>/m, 1]
      expect(tbody.index("Monthly Summary")).to be < tbody.index("Daily Sales")
    end
  end

  describe "POST /reports" do
    let(:user) { create(:user) }

    it "creates a report and redirects with a notice" do
      expect {
        post reports_path, params: { report: { user_id: user.id, report_type: "daily_sales" } }
      }.to change(Report, :count).by(1)

      expect(response).to redirect_to(reports_path(user_id: user.id, report_type: "daily_sales"))
      follow_redirect!
      expect(response.body).to include("Report queued successfully.")
    end

    it "responds with Turbo Stream when requested" do
      post reports_path,
        params: { report: { user_id: user.id, report_type: "daily_sales" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
      expect(response.body).to include(user.name)
    end

    it "redirects with an alert for duplicate user + type + day" do
      create(:report, user: user, report_type: :daily_sales)

      post reports_path, params: { report: { user_id: user.id, report_type: "daily_sales" } }

      expect(response).to redirect_to(reports_path(user_id: user.id, report_type: "daily_sales"))
      follow_redirect!
      expect(response.body).to include("already been generated today")
    end

    it "redirects with an alert for missing report type" do
      post reports_path, params: { report: { user_id: user.id } }

      expect(response).to redirect_to(reports_path(user_id: user.id))
      follow_redirect!
      expect(response.body).to include("Report type")
    end

    it "redirects with an alert for invalid user" do
      post reports_path, params: { report: { user_id: 0, report_type: "daily_sales" } }

      expect(response).to redirect_to(reports_path(user_id: 0, report_type: "daily_sales"))
      follow_redirect!
      expect(response.body).to include("User must exist")
    end
  end
end
