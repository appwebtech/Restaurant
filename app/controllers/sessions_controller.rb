class SessionsController < ApplicationController

	def new
		
	end

	def create
		chef = Chef.find_by(email: params[:session][:email].downcase) # No instance variable as it wont be used in views
		if chef && chef.authenticate(params[:session][:password]) # If chef exists & it authenticates
			session[:chef_id] = chef.id
			cookies.signed[:chef_id] = chef.id
			flash[:success] = "Login eseguita con successo"
			redirect_to chef
			else
				flash.now[:danger] = "Assicura che e-mail o password siano corrette" # .now method in flash will persist in only one HTTP request cycle and NOT in the next rendered form.
				render 'new'
			end
	end

	def destroy
		session[:chef_id] = nil
		flash[:success] = "Logout effettuato"
		redirect_to root_path
	end


end