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
		assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
		assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
	end

	test "should get recipes show" do 
		get recipe_path(@recipe)
		assert_template 'recipes/show'
		assert_match @recipe.name, response.body
		assert_match @recipe.description, response.body
		assert_match @chef.chefname, repsonse.body

	end

end
