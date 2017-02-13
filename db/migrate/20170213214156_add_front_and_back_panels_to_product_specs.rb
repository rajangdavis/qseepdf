class AddFrontAndBackPanelsToProductSpecs < ActiveRecord::Migration
  def change
  	 add_attachment :product_specs, :front_panel
  	 add_attachment :product_specs, :back_panel
  end
end
