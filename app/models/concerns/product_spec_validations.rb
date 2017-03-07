module ProductSpecValidations
	extend ActiveSupport::Concern
	included do
		before_validation do |model|
			methods_to_validate.each do |mtv|
				model.send(mtv).reject!(&:blank?) if model.send(mtv)
			end
		end

		def methods_to_validate
			['resolution','display_resolution','video_compression','display_modes','recording_modes','backup_methods','dual_stream','application_support','mobile_support','computer_support','network_ports','remote_control','connectors_or_cables','mounting_hardware','other_accessories','ptz_protocols']
		end
	end

	module Recorders
		extend ActiveSupport::Concern
		
		included do
			has_attached_file :front_panel
			has_attached_file :back_panel
			validates_attachment_content_type :front_panel, :content_type => /\Aimage\/.*\Z/
			validates_attachment_content_type :back_panel, :content_type => /\Aimage\/.*\Z/
		end
	end
end	