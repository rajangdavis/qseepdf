module ProductSpecsHelper
	def pdf_view
		'pdf_view' unless @rendered_as == 'pdf'
	end
end
