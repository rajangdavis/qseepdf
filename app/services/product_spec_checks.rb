class ProductSpecChecks
	def self.generate_checks(product_spec)
        @product_spec = product_spec
        @check_for_basic_info = @product_spec.check_for_basic_info
        @check_for_recording_resolution = @product_spec.check_for_recording_resolution
        @check_for_recording_modes = @product_spec.check_for_recording_modes
        @check_for_remote_monitoring = @product_spec.check_for_remote_monitoring
        @check_for_compatibility = @product_spec.check_for_compatibility
        @check_for_av_ports = @product_spec.check_for_av_ports
        @check_for_communication_ports = @product_spec.check_for_communication_ports
        @check_for_accessories = @product_spec.check_for_accessories
        @check_for_ptz = @product_spec.check_for_ptz
        @check_for_power = @product_spec.check_for_power
        @check_for_physical = @product_spec.check_for_physical
    end
end