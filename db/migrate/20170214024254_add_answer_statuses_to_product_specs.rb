class AddAnswerStatusesToProductSpecs < ActiveRecord::Migration
  def change
  	add_column :product_specs, :answer_status, :string
  end
end
