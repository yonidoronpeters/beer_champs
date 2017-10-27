class AddAthleteToActivities < ActiveRecord::Migration[4.2]
  def change
    add_reference :activities, :athlete, index: true
    add_foreign_key :activities, :athletes
    add_index :activities, [:athlete_id, :created_at]
  end
end
