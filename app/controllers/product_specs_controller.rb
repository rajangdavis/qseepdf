class ProductSpecsController < ApplicationController
    before_action :set_product_spec, only: [:show, :edit, :update]
    
    def new
        @product_spec = ProductSpec.new
        create
    end

    def duplicate
        @ptc = params[:product_to_copy]
        @sku = params[:sku]

        @product_to_copy = ProductSpec.where('sku = ?',@ptc)

        @copied_prod = @product_to_copy[0].dup

        @copied_prod.sku = @sku

        if @copied_prod.save
            redirect_to product_spec_path(@copied_prod)
        else
            @error = @copied_prod
        end
    end

    def create
        @product_spec = ProductSpec.new(product_spec_params)
        if @product_spec.save
            redirect_to edit_product_spec_path(@product_spec)
        end
    end

    def show
        respond_to do |format|
            format.pdf do
                @rendered_as = "pdf"
                render pdf: "#{@product_spec.sku_or_nil}",
                       title: "#{@product_spec.sku_or_nil} Product Specifications",
                       margin:{top: 20,bottom:15},
                       footer:{html: {template: 'product_specs/pdf_parts/_footer.html.erb',layout: 'application'}},
                       header:{html: {template: 'product_specs/pdf_parts/_header.html.erb',layout: 'application'}}
            end
            format.html do
                @rendered_as = "html"
                render erb: "show.html.erb"
            end
        end
    end

    def index
        @product_specs = ProductSpec.all
        @product_spec = ProductSpec.new
        @rn_product_types = OSCRuby::ServiceProduct.where(rn_test_client,"parent IS NULL and id !=83 and lookupName NOT LIKE '%TEST%'").map{|sp| sp.name}
    end

    def edit
        @template = params[:template] 
        if @product_spec.product_series.nil? || @template == "product_specs/product_specs_form/add_series_and_name"
            @rn_product_series = OSCRuby::ServiceProduct.where(rn_test_client,"parent.lookupName = '#{@product_spec.product_type}'").map{|sp| sp.name}
        end

        generate_checks_and_form_attrs(@product_spec)
    end

    def update
        if @product_spec.update(product_spec_params)
            redirect_to edit_product_spec_path(@product_spec)
        else
          redirect_to :back
        end
    end

    def destroy
    end

    private

    def set_product_spec
        @product_spec = ProductSpec.find(params[:id])       
        if !@product_spec.product_type.nil? and @product_spec.product_type.match(/(Recorder|DVR)/)
            @product_spec = RecorderSpec.find(params[:id])
        elsif !@product_spec.product_type.nil? and @product_spec.product_type.match(/(Camera)/)
            @product_spec = CameraSpec.find(params[:id])
        end
        @product_spec
    end

    def product_spec_params
        
        # white_list_attrs defined in the application controller

        params.require(:product_spec).permit(white_list_attrs)
    end
end