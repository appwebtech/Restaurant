class IngredientsController < ApplicationController 
	before_action :viungo, only: [:edit, :update, :show]
	before_action :require_admin, except: [:show, :index]

	def new
		@ingredient = Ingredient.new
	end

	def create
		@ingredient = Ingredient.new(uvoo_waku)
		if @ingredient.save
			flash[:success] = "Ingrediente creato con successo"
			redirect_to ingredient_path(@ingredient)
		else
			render 'new'
		end
	end

	def edit
		
	end

	def update
		if @ingredient.update(uvoo_waku)
			flash[:success] = "Il nome di ingrediente modificato con successo"
			redirect_to @ingredient
		else
			render 'edit'
		end
	end

	def show
		@ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
	end

	def index
		@ingredients = Ingredient.paginate(page: params[:page], per_page: 5)
	end

	private 

	def uvoo_waku
		params.require(:ingredient).permit(:name)
	end

	def viungo
		@ingredient = Ingredient.find(params[:id])
	end

	def require_admin
		if !logged_in? || (logged_in? and !current_chef.admin?)
			flash[:danger] = "Solo l'amministratore può complettare la richiesta"
			redirect_to ingredients_path 
		end
	end

end