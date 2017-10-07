require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com")   #Bang ensures that it hits the DB
		@recipe = Recipe.create(name: "pizza kebab", description: "pizza dough rolled, kebab, veggies on top and cheese of your liking", chef: @chef)
		@recipe2 = @chef.recipes.build(name: "chapati madondo", description: "Tayarisha mapocha na uandae na madondo.")
		@recipe2.save
	end

	test "should get recipes index" do 
		get recipes_path
		assert_response :success
	end

	test "should get recipes listing" do 
		get recipes_path 
		assert_template 'recipes/index'
		assert_match @recipe.name, response.body
		assert_match @recipe2.name, response.body
	end

end
