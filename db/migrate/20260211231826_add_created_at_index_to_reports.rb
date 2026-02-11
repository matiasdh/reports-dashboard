class AddCreatedAtIndexToReports < ActiveRecord::Migration[8.1]
  def change
    add_index :reports, :created_at, order: :desc
  end
end
