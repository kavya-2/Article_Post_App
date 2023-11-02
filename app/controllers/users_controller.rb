class UsersController < ApplicationController
	def new
		@user = User.new 
	end
	
	def create
		@user = User.new(user_params) 
		if @user.save 
			session[:user_id] = @user.id 
			redirect_to articles_path, notice: 'User created successfully!'
		else 
			flash.now[:notice] = @user.errors.full_messages
			render :new, status: :unprocessable_entity, content_type: "text/html"
		end
	end
	
	private
	
	def user_params 
		params.require(:user).permit(:name, :email, :password, :password_confirmation) 
	end
end
