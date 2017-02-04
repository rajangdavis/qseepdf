class ProductSpec < ActiveRecord::Base


	before_validation do |model|
	  model.resolution.reject!(&:blank?) if model.resolution
	  model.display_resolution.reject!(&:blank?) if model.display_resolution
	  model.video_compression.reject!(&:blank?) if model.video_compression
	  model.display_modes.reject!(&:blank?) if model.display_modes
	end

	def recording_resolutions 
		self.resolution.map {|rr| rr}.join("/")
	end

	def live_viewing_resolutions 
		self.display_resolution.map {|dr| dr}.join("/")
	end

	def live_fps
		"#{self.frames_per_second}FPS"
	end

	def hard_drive_support
		"Supports #{self.number_of_harddrives} HDD up to #{self.hard_drive_size}TB"
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

	def sku_or_nil

		if !self.sku.nil? 
			self.sku 
		else 
			'Unnamed Product' 
		end

	end

	def technology

		@sku = self.sku;

		if /Access/.match(self.product_type)
			return nil
		end

        if /QT7|QH7|QH8|QT6/.match(@sku)
            return 'SDI HD';
        elsif /QT8|QC8|QCN|QTN|QCK/.match(@sku)
            return 'IP HD';
        elsif /QC90|QC91|QCA|QC92|QC93|QC94|QC95|QT9|QTH|QTA/.match(@sku)
            return 'BNC HD';
        elsif /QCW/.match(@sku)
            return 'WI-FI';
        else
            return 'ANALOG';
		end

	end

	def product_compatibility

		@stripped_tech = self.technology.gsub(/( HD|-FI)/,'')
		@stripped_series = self.product_series.gsub(/( Series)/,'')
		if self.product_type.match(/(DVR\/NVR|Recorders)/)
			@opposite_product = 'Cameras'
		elsif self.product_type.match(/(Camer)/)
			@opposite_product = 'Recorders'
		end

		return "#{@stripped_series} #{@stripped_tech} #{@opposite_product}"

	end

	def os_compat

		if self.os_compatibility.nil?
            return 'Mac and PC'
        else
            return self.os_compatibility
        end
		
	end

	def check_for_basic_info
		if !self.technology.nil? && !self.sku.nil? && !self.channels.nil? && !self.recording_resolutions.nil? && !self.live_viewing_resolutions.nil? && !self.live_fps.nil? && !self.hard_drive_support.nil? && !self.remote_monitoring.nil? && !self.os_compatibility.nil? && !self.product_compatibility.nil? && !self.monitor_connections.nil?
			true
		else
			false
		end
	end

	def language_support
		if !self.product_series.nil? && self.product_series =="QC Series"
			"English, French, Spanish"
		elsif !self.product_series.nil? && self.product_series =="QT Series"
			"English, Chinese (Simplified & Traditional), Czech, French, Portuguese, Spanish, Turkish, Bulgarian, Greek, Italian, German, Russian, Polish, Japanese, Indonesian, Thai, Hungarian, Lithuanian, Vietnamese, Dutch, Swedish, Norwegian, Persian, Arabic, Romonian"
		end
	end

end