class CreateProductSpecs < ActiveRecord::Migration
  def change
    create_table :product_specs do |t|
      t.string :product_type
      t.string :product_series
      t.string :sku
      t.integer :channels
      t.text :resolution, default: [], array: true
      t.text :display_resolution, default: [], array: true
      t.integer :frames_per_second
      t.integer :hard_drive_size
      t.integer :number_of_harddrives
      t.integer :max_users
      t.string :connects_with
      t.string :os_compatibility
      t.string :monitor_connections
      t.text :video_compression, default: [], array: true
      t.text :display_modes, default: [], array: true
      t.text :recording_modes, default: [], array: true
      t.text :backup_methods, default: [], array: true
      t.text :playback_speed, default: [], array: true
      t.integer :max_channel_playback
      t.string :scan_n_view
      t.text :dual_stream, default: [], array: true
      t.integer :simultaneous_users
      t.text :application_support, default: [], array: true
      t.text :mobile_support, default: [], array: true
      t.text :computer_support, default: [], array: true
      t.integer :video_in
      t.integer :video_out
      t.integer :alarm_in
      t.integer :alarm_out
      t.integer :audio_in
      t.integer :audio_out
      t.text :network_ports, default: [], array: true
      t.string :usb_ports
      t.string :e_sata
      t.text :remote_control, default: [], array: true
      t.text :connectors_or_cables, default: [], array: true
      t.text :mounting_hardware, default: [], array: true
      t.text :other_accessorries, default: [], array: true
      t.string :ptz_support
      t.text :ptz_protocols, default: [], array: true
      t.string :power_supply
      t.string :power_consumption
      t.float :weight
      t.string :dimensions
      t.string :operating_temperature

      t.timestamps null: false
    end
  end
end
