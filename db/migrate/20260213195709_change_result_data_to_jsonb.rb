class ChangeResultDataToJsonb < ActiveRecord::Migration[8.1]
  def up
    change_column :reports, :result_data, :jsonb, using: "result_data::jsonb"
  end

  def down
    change_column :reports, :result_data, :text, using: "result_data::text"
  end
end
