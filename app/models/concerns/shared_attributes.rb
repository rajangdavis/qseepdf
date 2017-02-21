module SharedAttributes
	extend ActiveSupport::Concern

	def conditional(condition,if_result,else_result)
	    if condition
	        return if_result
	    else
	        return else_result
	    end
	end

	def sku_or_nil
		conditional(!self.sku.nil?,self.sku,'Unnamed Product')
	end

	def technology

		@sku = self.sku;

		if /Access/.match(self.product_type)
			return nil
		end

        if /QT7|QH7|QH8|QT6/.match(@sku)
            return 'SDI HD'
        elsif /QT8|QC8|QCN|QTN|QCK/.match(@sku)
            return 'IP HD'
        elsif /QC90|QC91|QCA|QC92|QC93|QC94|QC95|QT9|QTH|QTA/.match(@sku)
            return 'BNC HD'
        elsif /QCW/.match(@sku)
            return 'WI-FI'
        else
            return 'ANALOG'
		end

	end

	def product_compatibility

		@stripped_tech = self.technology.gsub(/( HD|-FI)/,'')
		if !self.product_series.nil?
			@stripped_series = self.product_series.gsub(/( Series)/,'')
		end
		if self.product_type.match(/(DVR\/NVR|Recorders)/)
			@opposite_product = 'Cameras'
		elsif self.product_type.match(/(Camer)/)
			@opposite_product = 'Recorders'
		end

		return "#{@stripped_series} #{@stripped_tech} #{@opposite_product}"

	end

end