class RemoveFilePathFromReports < ActiveRecord::Migration[8.1]
  def change
    remove_column :reports, :file_path, :string
  end
end
