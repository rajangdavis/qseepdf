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
        @check_for_compatibility = @product_spec.check_for_compatibility
        @check_for_av_ports = @product_spec.check_for_av_ports
        @check_for_communication_ports = @product_spec.check_for_communication_ports
        @check_for_accessories = @product_spec.check_for_accessories
        @check_for_ptz = @product_spec.check_for_ptz
        @check_for_power = @product_spec.check_for_power
        @check_for_physical = @product_spec.check_for_physical
    end

    def generate_spec_form_attrs
        @channels = map_to_select([1,2,4,8,9,10,12,16,32])
        @display_channels = map_to_select([1,4,8,9,16,"Auto Sequence"])
        @recording_resolutions = map_to_select(['12MP','8MP','6MP','5MP','4MP','3MP','1080p','720p','D1'])
        @display_resolutions = map_to_select(['4k','1080p','1280x1024','720p','1024x768'])
        @video_compression = map_to_select(['H.265','H.264','MJPEG','MJPEG4'])
        @recording_modes = map_to_select(['Manual','Time Schedule','Motion Detection','Sensor'])
        @backup_methods = map_to_select(['PC','USB Flash','Hard Drive'])
        @dual_stream_options = map_to_select(['D1 @ 15 FPS','CIF @ 30 FPS'])
        @yes_or_no = map_to_select(['Yes','No'])
        @supported_softwares = map_to_select(['QC View','QT View'])
        @supported_mobile_devices = map_to_select(['Android','iPhone','iPad'])
        @supported_operating_systems = map_to_select(['Windows XP','Windows Vista','Windows 7,8,10','Mac OSX 10.7+'])
        @network_ports = map_to_select(["10","100","1000"])
        @remote_control = map_to_select(["USB Mouse","Remote Control"])
        @connectors_or_cables = map_to_select(["HDMI Cable"])
        @mounting_hardware = map_to_select(["Screws for Hard Drive"])
        @other_accessories = map_to_select(["Quick Start Guide"])
        @ptz_protocols = map_to_select(["COC","Null ","Pelco P","Pelco D","Lilin","Minking","Neon","Star","VIDO","DSCP","VISCA","Samsung","RM110","HY"])
    end

    def map_to_select(arr)
        arr.map{|arr_contents|[arr_contents,arr_contents]}
    end

    def product_spec_params
        params.require(:product_spec).permit(:product_type,:number_of_hd,:ptz_support,:sku,:channels,{:resolution => []},:frames_per_second,:hard_drive_size,:max_users,:connects_with,:os_compatibility,:monitor_connections,{:video_compression=>[]},{:display_modes=>[]},{:recording_modes=>[]},{:backup_methods=>[]},:playback_speed,:max_channel_playback,:scan_n_view,{:dual_stream=>[]},:simultaneous_users,{:application_support=>[]},{:mobile_support=>[]},{:computer_support=>[]},:video_in,:video_out,:alarm_in,:alarm_out,:audio_in,:audio_out,{:network_ports=>[]},:usb_ports,:e_sata,{:remote_control=>[]},{:connectors_or_cables=>[]},{:mounting_hardware=>[]},{:other_accessories=>[]},:maximum_hd_size,{:ptz_protocols=>[]},:power_supply,:power_consumption,:weight,:dimensions,:operating_temperature,:created_at,:updated_at,:product_series,{:display_resolution=>[]},:number_of_harddrives,:front_panel,:back_panel,:answer_status,:user_id,:rightnow_answer_id)
    end
end