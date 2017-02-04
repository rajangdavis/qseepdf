class CreateRecordingResolutions < ActiveRecord::Migration
  def change
    create_table :recording_resolutions do |t|
      t.string :name
      t.string :pixels

      t.timestamps null: false
    end
  end
end
