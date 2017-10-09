require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
	def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com")   #Bang ensures that it hits the DB
		@recipe = Recipe.create(name: "Pasta Babbo Natale", description: "Preparare la pasta il 24 dicembre circa le 23:00, lasciare in forno ad una temperatura moderata, aspettare babbo in cammino e macinare il suo braccio per ragù", chef: @chef)
	end

	test "reject invalid recipe update" do 
		get edit_recipe_path(@recipe)
		assert_template 'recipes/edit'
		patch recipe_path(@recipe), params: { recipe: { name: " ", description: "qualche cazzata..."} }
		assert_template 'recipes/edit'
		assert_select 'h2.panel-title'
		assert_select 'div.panel-body'
	end

	test "successfully edit a recipe" do 

	end
end
