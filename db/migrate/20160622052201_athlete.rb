class Athlete < ActiveRecord::Migration[4.2]
  def change
    add_column :athletes, :username, :string
  end
end
