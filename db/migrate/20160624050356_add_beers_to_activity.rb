class AddBeersToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :beers, :integer
  end
end
