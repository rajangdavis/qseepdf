class ProductSpecsController < ApplicationController
    
    def new
        @product_spec = ProductSpec.new
        create
    end

    def create
        @product_spec = ProductSpec.new(product_spec_params)
        if @product_spec.save
            redirect_to edit_product_spec_path(@product_spec)
        end
    end

    def show
        @product_spec = ProductSpec.find(params[:id])
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
        @product_spec = ProductSpec.find(params[:id])

        if @product_spec.product_series.nil?
            @rn_product_series = OSCRuby::ServiceProduct.where(rn_test_client,"parent.lookupName = '#{@product_spec.product_type}'").map{|sp| sp.name}
        end

        RecorderSpecFormAttrs.generate_spec_form_attrs
        ProductSpecChecks.generate_checks(@product_spec)
    end

    def update
        @product_spec = ProductSpec.find(params[:id])
        if @product_spec.update(product_spec_params)
            redirect_to edit_product_spec_path(@product_spec)
        else
          redirect_to :back
        end
    end

    def destroy
    end

    private

    def product_spec_params
        params.require(:product_spec).permit(:product_type,:number_of_hd,:ptz_support,:sku,:channels,{:resolution => []},:frames_per_second,:hard_drive_size,:max_users,:connects_with,:os_compatibility,:monitor_connections,{:video_compression=>[]},{:display_modes=>[]},{:recording_modes=>[]},{:backup_methods=>[]},:playback_speed,:max_channel_playback,:scan_n_view,{:dual_stream=>[]},:simultaneous_users,{:application_support=>[]},{:mobile_support=>[]},{:computer_support=>[]},:video_in,:video_out,:alarm_in,:alarm_out,:audio_in,:audio_out,{:network_ports=>[]},:usb_ports,:e_sata,{:remote_control=>[]},{:connectors_or_cables=>[]},{:mounting_hardware=>[]},{:other_accessories=>[]},:maximum_hd_size,{:ptz_protocols=>[]},:power_supply,:power_consumption,:weight,:dimensions,:operating_temperature,:created_at,:updated_at,:product_series,{:display_resolution=>[]},:number_of_harddrives,:front_panel,:back_panel,:answer_status,:user_id,:rightnow_answer_id)
    end
end