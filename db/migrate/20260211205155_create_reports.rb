class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code, null: false
      t.integer :status, null: false, default: 0
      t.integer :report_type, null: false
      t.text :result_data
      t.string :file_path

      t.timestamps
    end

    add_index :reports, :code, unique: true
  end
end
