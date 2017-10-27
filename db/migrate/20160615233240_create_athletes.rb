class CreateAthletes < ActiveRecord::Migration[4.2]
  def change
    create_table :athletes do |t|
      t.string :name
      t.decimal :calories
      t.decimal :beers
      t.string :activity
      t.string :img_url

      t.timestamps null: false
    end
  end
end
