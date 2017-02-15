module FormModelChecking
	extend ActiveSupport::Concern
	module Recorders

		# Various checks when filling out the forms

		def check_for_basic_info
			check = !self.sku.nil? && !self.channels.nil? && !self.recording_resolutions.nil? && !self.live_viewing_resolutions.nil? && !self.live_fps.nil? && !self.hard_drive_support.nil? && !self.remote_monitoring.nil? && !self.os_compatibility.nil? && !self.product_compatibility.nil? && !self.monitor_connections.nil?
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
			check = !self.video_in.nil? && !self.alarm_in.nil? && !self.alarm_out.nil? && !self.audio_in.nil? && !self.audio_out.nil?
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

	end
	
end