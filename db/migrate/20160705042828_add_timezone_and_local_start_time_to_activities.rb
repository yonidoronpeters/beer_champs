class AddTimezoneAndLocalStartTimeToActivities < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :timezone, :string
    add_column :activities, :start_date_local, :datetime
  end
end
