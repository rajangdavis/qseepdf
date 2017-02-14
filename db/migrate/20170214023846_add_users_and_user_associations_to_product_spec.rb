class AddUsersAndUserAssociationsToProductSpec < ActiveRecord::Migration
	def change
	  	create_table :users do |t|
			t.string :username
			t.string :password_digest
			t.string :role
			t.timestamps
		end

		add_column :product_specs, :user_id, :integer
		add_column :product_specs, :rightnow_answer_id, :integer
    	add_index 'product_specs', ['user_id'], :name => 'index_user_id'
	end
end
