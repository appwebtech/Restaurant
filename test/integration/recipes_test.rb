require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com",   #Bang ensures that it hits the DB
												password: "password", password_confirmation: "password")
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
		sign_in_as(@chef, "password")
		get recipe_path(@recipe)
		assert_template 'recipes/show'
	#	assert_match @recipe.name, response.body
		assert_match @recipe.description, response.body
		assert_match @chef.chefname, response.body
		assert_select 'a[href=?]', edit_recipe_path(@recipe), text: "Modifica questa ricetta"
		assert_select 'a[href=?]', recipe_path(@recipe), text: "Cancella questa ricetta"
		assert_select 'a[href=?]', recipes_path, text: "Torna nella lista delle ricette"
	end

	test "create new valid recipe" do 
		sign_in_as(@chef, "password")
		get new_recipe_path
		assert_template 'recipes/new'
		name_of_recipe = "githeri without the man"
		description_of_recipe = "Buy githeri, have it put in a polythene bag then snack it on queue whilst waiting to vote"
		assert_difference 'Recipe.count', 1 do 
			post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe}}
		end
		follow_redirect!
		assert_match name_of_recipe.capitalize, response.body 
		assert_match description_of_recipe, response.body
	end

	test "reject invalid recipe submissions" do 
		get new_recipe_path
		assert_template 'recipes/new'
		assert_no_difference 'Recipe.count' do 
			post recipes_path, params: { recipe: { name: " ", description: " "}}
		end
		assert_template 'recipes/new'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end
end
