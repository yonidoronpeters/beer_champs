class ChangeTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :activities, :type, :activity_type
  end
end
