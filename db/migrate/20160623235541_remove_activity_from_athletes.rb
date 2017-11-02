class RemoveActivityFromAthletes < ActiveRecord::Migration[4.2]
  def change
    remove_column :athletes, :activity, :string
  end
end
