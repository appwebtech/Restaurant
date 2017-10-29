class RecipesController < ApplicationController
	before_action :mashakura, only: [:show, :edit, :update, :destroy, :like]
	before_action :require_user, except: [:index, :show, :like]
	before_action :require_same_user, only: [:edit, :update, :destroy]
	before_action :require_user_like, only: [:like]

	

	def index
		@recipes = Recipe.paginate(page: params[:page], per_page: 5)
	end

	def show
		@comment = Comment.new
		@comments = @recipe.comments.paginate(page: params[:page], per_page: 5)
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

	def like
		  like = Like.create(like: params[:like], chef: current_chef, recipe: @recipe)
	  if like.valid?
	    flash[:success] = "L'operazione completata con successo"
	    redirect_to :back
	  else
	    flash[:danger] = "Questa operazione va fatta una volta solo"
	    redirect_to :back
	  end
	end

	private

	def mashakura
		@recipe = Recipe.find(params[:id])
		
	end

	def recipe_params
		params.require(:recipe).permit(:name, :description, ingredient_ids: [])
	end

	def require_same_user
		if current_chef != @recipe.chef and !current_chef.admin?
			flash[:danger] = "Non puoi modificare od eliminare le ricette degli altri"
			redirect_to recipes_path 
		end
	end

	def require_user_like
  if !logged_in?
    flash[:danger] = "Devi accedere o registrarsi per complettare questa operazione"
    redirect_to :back
  end
end

end