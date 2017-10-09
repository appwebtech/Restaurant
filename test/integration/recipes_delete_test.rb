require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
		def setup
		@chef = Chef.create!(chefname: "josembi", email: "josembi@gmail.com")   #Bang ensures that it hits the DB
		@recipe = Recipe.create(name: "pilau kenya", description: "basmati rice, meat (mutton/beef/goat/chicken/~aliens? ha ha), spices, carrots, tomatoes, garlic, onion, etc", chef: @chef)
	end

	test "successfully delete a recipe" do 
		get recipe_path(@recipe)
		assert_template 'recipes/show'
		assert_select 'a[href=?]', recipe_path(@recipe), text: "Cancella questa ricetta"
		assert_difference 'Recipe.count', -1 do 
			delete recipe_path(@recipe)
		end
		assert_redirected_to recipes_path
		assert_not flash.empty?
	end
end
