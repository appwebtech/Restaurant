class RecipesController < ApplicationController
	before_action :mashakura, only: [:show, :edit, :update, :destroy]
	before_action :require_user, except: [:index, :show]
	before_action :require_same_user, only: [:edit, :update, :destroy]
	def index
		@recipes = Recipe.paginate(page: params[:page], per_page: 5)
	end

	def show
	
	end

	def new
		@recipe = Recipe.new
	end

	def create
		@recipe = Recipe.new(recipe_params)
		@recipe.chef = current_chef
		if @recipe.save
			flash[:success] = "Ricetta creata con successo"
			redirect_to recipe_path(@recipe)
		else
			render 'new'
		end
	end

	def edit
		
	end

	def update
		if @recipe.update(recipe_params)
				flash[:success] = "Modifica effettuata con successo"
				redirect_to recipe_path(@recipe)
			else
				render 'edit'
			end
	end

	def destroy
		@recipe = Recipe.find(params[:id]).destroy
		flash[:success] = "Ricetta cancellata con successo"
		redirect_to recipes_path
	end

	private

	def mashakura
		@recipe = Recipe.find(params[:id])
		
	end

	def recipe_params
		params.require(:recipe).permit(:name, :description)
	end

	def require_same_user
		if current_chef != @recipe.chef and !current_chef.admin?
			flash[:danger] = "Non puoi modificare od eliminare le ricette degli altri"
			redirect_to recipes_path 
		end
	end

end