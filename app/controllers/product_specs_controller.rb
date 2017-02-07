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
                render pdf: "show",
                       title: "#{@product_spec.sku_or_nil} Product Specifications",
                       margin:{
                           top: 20,bottom:15
                       },
                       footer:{
                           html: {            
                               template: 'product_specs/pdf_parts/_footer.html.erb',
                               layout: 'application'
                           }
                       },
                       header:{
                           html: {            
                               template: 'product_specs/pdf_parts/_header.html.erb',
                               layout: 'application'
                           }
                       }
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
        @rn_product_types = OSCRuby::ServiceProduct.where(rn_test_client,"parent IS NULL and id !=83").map{|sp| sp.name}
    end

    def edit
        @product_spec = ProductSpec.find(params[:id])

        if @product_spec.product_series.nil?
            @rn_product_series = OSCRuby::ServiceProduct.where(rn_test_client,"parent.lookupName = '#{@product_spec.product_type}'").map{|sp| sp.name}
        end

        generate_spec_form_attrs
        generate_checks(@product_spec)
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

    def generate_checks(product_spec)
        @product_spec = product_spec
        @check_for_basic_info = @product_spec.check_for_basic_info
        @check_for_recording_resolution = @product_spec.check_for_recording_resolution
        @check_for_recording_modes = @product_spec.check_for_recording_modes
        @check_for_remote_monitoring = @product_spec.check_for_remote_monitoring
    end

    def generate_spec_form_attrs
        @channels = [1,2,4,8,9,10,12,16,32].map{|ch| [ch,ch]}
        @recording_resolutions = ['12MP','8MP','6MP','5MP','4MP','3MP','1080p','720p','D1'].map{|rr| [rr,rr]}
        @display_resolutions = ['4k','1080p','1280x1024','720p','1024x768'].map{|dr| [dr,dr]}
        @video_compression = ['H.265','H.264','MJPEG','MJEPG4'].map{|vc| [vc,vc]}
        @recording_modes =['Manual','Time Schedule','Motion Detection','Sensor'].map{|rm| [rm,rm]}
        @backup_methods = ['PC','USB Flash','Hard Drive'].map{|bm| [bm,bm]}
        @dual_stream_options = ['D1 @ 15 FPS','CIF @ 30 FPS'].map{|bm| [bm,bm]}
        @yes_or_no = ['Yes','No'].map{|yn| [yn,yn]}
    end

    def product_spec_params
        params.require(:product_spec).permit(:product_type,:number_of_hd,:ptz_support,:sku,:channels,{:resolution => []},:frames_per_second,:hard_drive_size,:max_users,:connects_with,:os_compatibility,:monitor_connections,{:video_compression=>[]},{:display_modes=>[]},{:recording_modes=>[]},{:backup_methods=>[]},:playback_speed,:max_channel_playback,:scan_n_view,{:dual_stream=>[]},:simultaneous_users,:application_support,:mobile_support,:computer_support,:video_in,:video_out,:alarm_in,:alarm_out,:audio_in,:audio_out,:network_ports,:usb_ports,:e_sata,:remote_control,:connectors_or_cables,:mounting_hardware,:other_accessorries,:maximum_hd_size,:ptz_protocols,:power_supply,:power_consumption,:weight,:dimensions,:operating_temperature,:created_at,:updated_at,:product_series,{:display_resolution=>[]},:number_of_harddrives)
    end
end