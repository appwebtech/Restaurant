class ChefsController < ApplicationController 

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
	end




	private

	def kiboko_yao
		params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
		
	end


end