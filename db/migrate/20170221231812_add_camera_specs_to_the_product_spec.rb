class AddCameraSpecsToTheProductSpec < ActiveRecord::Migration
	def change

  		# The following is what is needed to build a camera spec sheet

  		#basic info
  		add_column :product_specs, :camera_type, :string
		add_column :product_specs, :image_sensor_size, :string
		add_column :product_specs, :sensor_type, :string
		add_column :product_specs, :image_resolution, :string
		add_column :product_specs, :effective_pixels, :string
		add_column :product_specs, :lens_size, :string
		add_column :product_specs, :angle_of_view_min, :integer
		add_column :product_specs, :angle_of_view_max, :integer
		add_column :product_specs, :ir_cut_filter, :string # (yes or no)

		# night_vision
		add_column :product_specs, :ir_leds, :integer
		add_column :product_specs, :infrared_wavelength, :integer
		add_column :product_specs, :min_lux_illumination, :integer
		add_column :product_specs, :night_vision_range, :integer

		# additional_image_features
		add_column :product_specs, :auto_iris, :string #(yes or no)
		add_column :product_specs, :on_screen_display, :string #(yes or no)
		add_column :product_specs, :backlight_compensation, :string #(yes or no)
		add_column :product_specs, :electronic_shutter, :string
		add_column :product_specs, :gain_control, :string
		add_column :product_specs, :wide_dynamic_range, :string
		add_column :product_specs, :noise_reduction, :string

		# remote_monitoring
		add_column :product_specs, :use_as_standalone, :string #(yes or no)
		# mobile_support (already created)
		# compatible

		# physical_attributes
		add_column :product_specs, :weather_proof, :string #(yes or no)
		add_column :product_specs, :ip_rating, :string, array: true, default: [] #[‘IP5’,’IP66’]
		add_column :product_specs, :body_construction, :string
		add_column :product_specs, :dimension_with_bracket, :string
		# :operating_temperature (already exists)
		# mounting_hardware (already exists)
		# add_column :product_specs, :weight => (already exists) integer + ‘oz’
		# dimensions_w/o_bracket (already exists)

		# ptz
		add_column :product_specs, :horizontal_rotation, :string 
		add_column :product_specs, :vertical_tilt, :string 
		add_column :product_specs, :preset_and_cruise_patterns, :string, array: true, default: [] 
		# => ['300 Presets','5 pattern','8 tour','Auto Pan','Auto Scan']
		add_column :product_specs, :ptz_zoom, :string, array: true, default: [] 
		# => [‘4x Optical’,’16 x Optical’,'30x Optical']
		add_column :product_specs, :ptz_focus, :string

		# audio
		# use audio_in  and audio out possibly?
		add_column :product_specs, :audio_range, :string
		add_column :product_specs, :audio_microphone, :string

		# connectivity
		# connector_types => infer from technology
		add_column :product_specs, :other_connections, :string
		add_column :product_specs, :wireless, :string #(yes or no)

		# power
		# power_supply (already created)
		# power_consumption (already created)
	end

end