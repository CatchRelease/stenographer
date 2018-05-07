# frozen_string_literal: true

class CreateStenographerChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :stenographer_changes do |t|
      t.string :message, null: false
      t.boolean :visible, default: true, null: false
      t.string :change_type
      t.string :environment
      t.string :tracker_ids
      t.text :source

      t.timestamps
    end
  end
end
