require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com",   #Bang ensures that it hits the DB
													password: "password", password_confirmation: "password")
		@recipe = Recipe.create(name: "Pasta Babbo Natale", description: "Preparare la pasta il 24 dicembre circa le 23:00, lasciare in forno ad una temperatura moderata, aspettare babbo in cammino e macinare il suo braccio per ragù", chef: @chef)
	end

	test "reject invalid recipe update" do 
		sign_in_as(@chef, "password")
		get edit_recipe_path(@recipe)
		assert_template 'recipes/edit'
		patch recipe_path(@recipe), params: { recipe: { name: " ", description: "qualche cazzata..."} }
		assert_template 'recipes/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end

	test "successfully edit a recipe" do
		sign_in_as(@chef, "password")
		get edit_recipe_path(@recipe)
		assert_template 'recipes/edit'
		updated_name = "updated recipe name"
		updated_description = "updated recipe description"
		patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description } }
		assert_redirected_to @recipe
		#follow_redirect!
		assert_not flash.empty?
		@recipe.reload
		assert_match updated_name, @recipe.name
		assert_match updated_description, @recipe.description
	end
end
