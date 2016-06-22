class Athlete < ActiveRecord::Migration
  def change
    add_column :athletes, :username, :string
  end
end
