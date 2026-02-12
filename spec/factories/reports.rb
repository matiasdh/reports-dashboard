FactoryBot.define do
  factory :report do
    user
    report_type { Report.report_types.keys.sample }
    status { :pending }

    trait :processing do
      status { :processing }
    end

    trait :fetching_data do
      status { :fetching_data }
    end

    trait :completed do
      status { :completed }
      result_data { { total_sales: 1234.56, items_count: 42 }.to_json }
      file_path { "/reports/#{SecureRandom.hex(8)}.pdf" }
    end

    trait :failed do
      status { :failed }
    end
  end
end
