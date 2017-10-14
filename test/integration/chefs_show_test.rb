require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com",   #Bang ensures that it hits the DB
												password: "password", password_confirmation: "password")
		@recipe = Recipe.create(name: "pizza kebab", description: "pizza dough rolled, kebab, veggies on top and cheese of your liking", chef: @chef)
		@recipe2 = @chef.recipes.build(name: "chapati madondo", description: "Tayarisha mapocha na uandae na madondo.")
		@recipe2.save
	end

	test "should get chefs show" do 
		get chef_path(@chef)
		assert_template 'chefs/show'
		assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
		assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
		assert_match @recipe.description, response.body
		assert_match @recipe.description, response.body
		assert_match @chef.chefname, response.body
	end
end
