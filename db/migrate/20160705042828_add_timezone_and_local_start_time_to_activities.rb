class AddTimezoneAndLocalStartTimeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :timezone, :string
    add_column :activities, :start_date_local, :datetime
  end
end
