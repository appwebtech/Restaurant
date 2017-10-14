class ChefsController < ApplicationController 

	def index
		@chefs = Chef.paginate(page: params[:page], per_page: 5 )
	end

	def new
		@chef = Chef.new
	end

	def create
		@chef = Chef.new(kiboko_yao)
		if @chef.save
				flash[:success] = "Benvenuto #{@chef.chefname} nell'app di ricette"
				redirect_to chef_path(@chef)
			else
				render 'new'
			end
	end

	def show
		@chef = Chef.find(params[:id])
		@chef_ricette =@chef.recipes.paginate(page: params[:page], per_page: 5)
	end

	def edit
		@chef = Chef.find(params[:id])
	end

	def update
		@chef = Chef.find(params[:id])
		if @chef.update(kiboko_yao)
			flash[:success] = "Il tuo profilo è stata aggiornato con successo"
			redirect_to @chef
		else
			render 'edit'
		end
		
	end



	private

	def kiboko_yao
		params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
		
	end


end