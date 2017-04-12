module FormModelChecking
	extend ActiveSupport::Concern
	module Recorders

		# Various checks when filling out the forms

		def check_for_basic_info
			check = !self.sku.nil? && !self.channels.nil? && !self.resolution.empty? && !self.display_resolution.empty? && !self.live_fps.nil? && !self.number_of_harddrives.nil? && !self.hdd_tb.nil? && !self.max_users.nil? && !self.os_compatibility.nil? && !self.product_compatibility.nil?
			conditional(check,true,false)
		end

		def check_for_recording_resolution
			check = !self.video_compression.empty? && !self.display_modes.empty?
			conditional(check,true,false)
		end

		def check_for_recording_modes
			check = !self.recording_modes.empty? && !self.backup_methods.empty?
			conditional(check,true,false)
		end

		def check_for_remote_monitoring
			check = !self.scan_n_view.nil? && !self.dual_stream.nil?
			conditional(check,true,false)
		end

		def check_for_compatibility
			check = !self.application_support.empty? && !self.mobile_support.empty? && !self.computer_support.empty?
			conditional(check,true,false)
		end

		def check_for_av_ports
			check = !self.video_in.nil? && !self.alarm_in.nil? && !self.alarm_out.nil? && !self.audio_in.nil? && !self.audio_out.nil? && !self.monitor_connections.nil?
			conditional(check,true,false)
		end

		def check_for_communication_ports
			check = !self.network_ports.empty? && !self.usb_ports.nil? && !self.e_sata.nil?
			conditional(check,true,false)
		end

		def check_for_accessories
			check = !self.remote_control.empty? && !self.connectors_or_cables.empty? && !self.mounting_hardware.empty? && !self.other_accessories.empty?	
			conditional(check,true,false)
		end

		def check_for_ptz
			check = !self.ptz_support.nil? && !self.ptz_protocols.empty?
			conditional(check,true,false)
		end

		def check_for_power
			check = !self.power_supply.nil? && !self.power_consumption.nil?
			conditional(check,true,false)
		end

		def check_for_physical
			check = !self.weight.nil? && !self.dimensions.nil? && !self.operating_temperature.nil?		
			conditional(check,true,false)
		end

		def check_for_photos
			check = !self.front_panel_file_name.nil? && !self.back_panel_file_name.nil?
			conditional(check,true,false)
		end

	end

	module Cameras

		# Various checks when filling out the forms

		def check_for_basic_info
			check = !self.sku.nil? && !self.camera_type.nil? &&!self.image_sensor_size.nil? &&!self.sensor_type.nil? &&!self.image_resolution.nil? &&!self.effective_pixels.nil? &&!self.lens_size.nil? &&!self.angle_of_view_min.nil? &&!self.angle_of_view_max.nil? &&!self.ir_cut_filter.nil?
			conditional(check,true,false)
		end

		def check_for_night_vision
			check = !self.ir_leds.nil? && !self.infrared_wavelength.nil? && !self.min_lux_illumination.nil? && !self.night_vision_range.nil?
			conditional(check,true,false)
		end

		def check_for_additional_image_features
			check = !self.auto_iris.nil? && !self.on_screen_display.nil? && !self.backlight_compensation.nil? && !self.electronic_shutter.nil? && !self.gain_control.nil? && !self.wide_dynamic_range.nil? && !self.noise_reduction.nil? 
			conditional(check,true,false)
		end

		def check_for_remote_monitoring
			check = !self.use_as_standalone.nil? &&!self.mobile_support.nil? && !self.connects_with.nil?
			conditional(check,true,false)
		end

		def check_for_physical_attributes
			check = !self.weather_proof.nil? &&!self.ip_rating.empty? &&!self.body_construction.nil? &&!self.dimension_with_bracket.nil? &&!self.operating_temperature.nil? &&!self.mounting_hardware.nil? &&!self.weight.nil? &&!self.dimensions.nil?			
			conditional(check,true,false)
		end

		def check_for_ptz
			check = !self.horizontal_rotation.nil? && !self.vertical_tilt.nil? && !self.preset_and_cruise_patterns.empty? && !self.ptz_zoom.empty? && !self.ptz_focus.nil?
			conditional(check,true,false)
		end

		def check_for_audio
			check = !self.audio_range.nil? && !self.audio_microphone.nil?
			conditional(check,true,false)
		end

		def check_for_connectivity
			# figure out connector types
			check = !self.other_connections.nil? && !self.wireless.nil? 
			conditional(check,true,false)
		end

		def check_for_power
			check = !self.power_supply.nil? && !self.power_consumption.nil?
			conditional(check,true,false)
		end

		def check_for_photos
			check = !self.camera_image_file_name.nil?
			conditional(check,true,false)
		end

	end
	
end