class ChatroomsController < ApplicationController 

	def show
		@messages = Message.new
		@messages = Message.all
	end

end