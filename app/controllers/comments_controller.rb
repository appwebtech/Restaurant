class CommentsController < ApplicationController 
	before_action :require_user

	def create
		@recipe = Recipe.find(params[:recipe_id])
		@comment = @recipe.comments.build(comment_params)
		@comment.chef = current_chef
		if @comment.save
			flash[:success] = "Commento inserita correttamente"
			redirect_to recipe_path(@recipe)
		else
			flash[:danger] = "Non è stata possibile ad inserire il commento"
			redirect_to :back
		end
	end

	def edit
		
	end

	def update
		
	end

	private

	def comment_params
		params.require(:comment).permit(:description)
	end


end