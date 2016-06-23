class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|

      t.timestamps null: false
    end
  end
end
