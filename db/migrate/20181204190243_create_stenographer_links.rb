class CreateStenographerLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :stenographer_links do |t|
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
