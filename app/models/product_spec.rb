class ProductSpec < ActiveRecord::Base
	include SharedAttributes
end

class RecorderSpec < ProductSpec

	include FormModelChecking::Recorders
	include ProductSpecTerms::Recorders
	include ProductSpecValidations::Recorders

	def self.model_name
	    ProductSpec.model_name
	end

end

class CameraSpec < ProductSpec

	include FormModelChecking::Cameras

	def self.model_name
	    ProductSpec.model_name
	end

end