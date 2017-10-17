require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com",   
											password: "password", password_confirmation: "password")
		@chef2 = Chef.create!(chefname: "sembo", email: "sembo@example.com",   
											password: "password", password_confirmation: "password")
		@admin_user = Chef.create!(chefname: "josembi2", email: "josembi2@gmail.com",   
											password: "password", password_confirmation: "password", admin: true)
		
	end

	test "reject an invalid edit" do 
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: " ", email: "josembi@example.com" } }
		assert_template 'chefs/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end

	test "accept valid edit" do 
		sign_in_as(@chef, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "josembi1", email: "josembi1@example.com" } }
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "josembi1", @chef.chefname 
		assert_match "josembi1@example.com", @chef.email
	end 

	test "accept edit attempt by admin user" do 
		sign_in_as(@admin_user, "password")
		get edit_chef_path(@chef)
		assert_template 'chefs/edit'
		patch chef_path(@chef), params: { chef: { chefname: "sembo", email: "josembi@example.com" } }
		assert_redirected_to @chef
		assert_not flash.empty?
		@chef.reload
		assert_match "sembo", @chef.chefname 
		assert_match "josembi@example.com", @chef.email
	end

	test "redirect edit attempt by another by-admin user" do 
		sign_in_as(@chef2, "password")
		updated_name = "joe"
		updated_email = "joe@example.com"
		patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email } }
		assert_redirected_to chefs_path
		assert_not flash.empty?
		@chef.reload
		assert_match "josembi", @chef.chefname 
		assert_match "josembi@gmail.com", @chef.email
	end
end
