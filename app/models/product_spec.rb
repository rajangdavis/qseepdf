class ProductSpec < ActiveRecord::Base

	include FormModelChecking::Recorders
	include ProductSpecTerms::Recorders
	include ProductSpecValidations::Recorders

end