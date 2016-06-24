class RemoveActivityFromAthletes < ActiveRecord::Migration
  def change
    remove_column :athletes, :activity, :string
  end
end
