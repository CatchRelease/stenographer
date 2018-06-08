# frozen_string_literal: true

class CreateStenographerTables < ActiveRecord::Migration[5.2]
  def change
    create_table :stenographer_changes do |t|
      t.string :subject
      t.string :message, null: false
      t.boolean :visible, default: true, null: false
      t.string :change_type
      t.string :environment
      t.string :tracker_ids
      t.text :source

      t.timestamps
    end

    create_table :stenographer_authentications do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :credentials
      t.text :source

      t.timestamps
    end

    create_table :stenographer_outputs do |t|
      t.bigint :authentication_id, null: false
      t.text :configuration, null: false
      t.text :filters

      t.timestamps
    end
  end
end
