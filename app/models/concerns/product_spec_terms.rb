module ProductSpecTerms
	extend ActiveSupport::Concern
	module Recorders

		def recording_resolutions 
			self.resolution.map {|rr| rr}.join("/")
		end

		def live_viewing_resolutions 
			self.display_resolution.map {|dr| dr}.join("/")
		end

		def live_fps
			"#{self.frames_per_second}FPS"
		end

		def hdd_tb
			"#{self.hard_drive_size}TB"
		end

		def hard_drive_support
			"Supports #{self.number_of_harddrives} HDD up to #{self.hdd_tb}"
		end

		def remote_monitoring
			"#{self.max_users} Simultaneous Users"
		end

		def video_compression_list 
			self.video_compression.map {|vc| vc}.join("/")
		end

		def display_modes_list 
			self.display_modes.map {|dm| dm}.join("/")
		end

		def recording_modes_list 
			self.recording_modes.map {|rm| rm}.join(", ")
		end

		def backup_methods_list 
			self.backup_methods.map {|bm| bm}.join(", ")
		end

		def os_compat
			conditional(self.os_compatibility.nil?,'Mac and PC',self.os_compatibility)
		end

		def language_support
			if !self.product_series.nil? && self.product_series =="QC Series"
				"English, French, Spanish"
			elsif !self.product_series.nil? && self.product_series =="QT Series"
				"English, Chinese (Simplified & Traditional), Czech, French, Portuguese, Spanish, Turkish, Bulgarian, Greek, Italian, German, Russian, Polish, Japanese, Indonesian, Thai, Hungarian, Lithuanian, Vietnamese, Dutch, Swedish, Norwegian, Persian, Arabic, Romonian"
			end
		end

		def dual_stream_options_list
			conditional(!self.dual_stream.nil?,self.dual_stream.map{|ds| ds}.join(', '),'Dual Stream not supported')
		end

		def software_support_list
			self.application_support.map{|as| as}.join(', ')
		end

		def mobile_support_list
			self.mobile_support.map{|ms| ms}.join(', ')
		end

	 	def computer_support_list
	 		self.computer_support.map{|cs| cs}.join(', ')
	 	end

	 	def usb_support
	 		check = self.usb_ports.nil?
	 		if_true = '_ USB 2.0, _ USB 3.0'
	 		if_false = self.usb_ports
	 		conditional(check,if_true,if_false)
	 	end

	 	def e_sata_support
	 		check = self.e_sata.nil?
	 		if_true = 'None'
	 		if_false = self.e_sata
	 		conditional(check,if_true,if_false)
	 	end

	 	def video_in_tech
	 		if self.technology == "BNC HD"
	 			"#{self.video_in.to_s} BNC"
	 		elsif self.technology == "IP HD"
	 			"#{self.video_in.to_s} POE"
	 		end
	 	end

	 	def audio(attr)
	 		count = self.send(attr)
	 		"#{count} RCA"
	 	end

	 	def network_cap
	 		speed = self.network_ports.map {|n| n}.join('/')
	 		"RJ45 #{speed} Mbps"
	 	end

	 	def remote_control_options
	 		self.remote_control.map { |rc| rc }.join(',')
	 	end

	 	def connectors_or_cables_options
	 		self.connectors_or_cables.map { |coc| coc }.join(', ')
	 	end

	 	def mounting_hardware_options
	 		self.mounting_hardware.map { |mh| mh }.join(', ')
	 	end

	 	def other_accessories_options
	 		self.other_accessories.map { |oa| oa }.join(', ')
	 	end

	 	def ptz_protocol_options
	 		self.ptz_protocols.map { |pp| pp.gsub(/\s+/, "")  }.join(', ')
	 	end

	 	def weight_in_lbs
	 		"#{self.weight.to_s} lbs"
	 	end
	end
end