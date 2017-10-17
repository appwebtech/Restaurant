class ChefsController < ApplicationController 
	before_action :mambo_yote, only: [:show, :edit, :update, :destroy]  # Extracting redundancy (refactor code)
	before_action :require_same_user, only: [:edit, :update, :destroy]
	before_action :require_admin, only: [:destroy]

	def index
		@chefs = Chef.paginate(page: params[:page], per_page: 5 )
	end

	def new
		@chef = Chef.new
	end

	def create
		@chef = Chef.new(kiboko_yao)
		if @chef.save
				session[:chef_id] = @chef.id
				flash[:success] = "Benvenuto #{@chef.chefname} nell'app di ricette"
				redirect_to chef_path(@chef)
			else
				render 'new'
			end
	end

	def show
		@chef_ricette =@chef.recipes.paginate(page: params[:page], per_page: 5)
	end

	def edit
	end

	def update
		if @chef.update(kiboko_yao)
			flash[:success] = "Il tuo profilo è stata aggiornato con successo"
			redirect_to @chef
		else
			render 'edit'
		end
		
	end

	def destroy
		if !@chef.admin?
			@chef.destroy 
			flash[:danger] = "Il profilo con le ricette associato è stata eliminato"
			redirect_to chefs_path
	end


	private

	def kiboko_yao
		params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
		
	end

	def mambo_yote
		@chef = Chef.find(params[:id])
	end

	def require_same_user
		if current_chef != @chef and !current_chef.admin?
			flash[:danger] = "Puoi solo modificare od eliminare il proprio account"
			redirect_to chefs_path
		end
	end

	def require_admin
		if logged_in? && !current_chef.admin?
			flash[:danger] ="Solo l'amministratore può complettare la richiesta"
			redirect_to root_path
		end
	end


end