class AddBeersToActivity < ActiveRecord::Migration[4.2]
  def change
    add_column :activities, :beers, :integer
  end
end
