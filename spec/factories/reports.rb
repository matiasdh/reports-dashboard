FactoryBot.define do
  factory :report do
    user
    report_type { Report.report_types.keys.sample }
    status { :pending }

    trait :processing do
      status { :processing }
    end

    trait :completed do
      status { :completed }
      result_data { { total_sales: 1234.56, items_count: 42 }.to_json }
      after(:create) do |report|
        report.pdf.attach(
          io: StringIO.new("%PDF-1.4 mock"),
          filename: "#{report.code}.pdf",
          content_type: "application/pdf"
        )
      end
    end

    trait :failed do
      status { :failed }
    end
  end
end
