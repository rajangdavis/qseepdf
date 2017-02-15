class RecorderSpecFormAttrs

	def self.map_to_select(arr)
        arr.map{|arr_contents|[arr_contents,arr_contents]}
    end

    def self.generate_spec_form_attrs
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

end