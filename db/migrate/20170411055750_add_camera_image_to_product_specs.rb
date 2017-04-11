class AddCameraImageToProductSpecs < ActiveRecord::Migration
  def change
  	add_attachment :product_specs, :camera_image
  	add_column :product_specs, :audio_in_comments, :string
  	add_column :product_specs, :audio_out_comments, :string
  end
end
