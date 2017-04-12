class ProductSpec < ActiveRecord::Base
	include SharedAttributes
	validates :sku, uniqueness: true
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
	include ProductSpecTerms::Cameras
	include ProductSpecValidations::Cameras

	def self.model_name
	    ProductSpec.model_name
	end

end