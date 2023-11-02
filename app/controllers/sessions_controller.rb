class SessionsController < ApplicationController
	def new
		@user = User.new
	end
	
	def create 
		@user = User.find_by(email: params[:email]) 
		if @user && @user.authenticate(params[:password]) 
			session[:user_id] = @user.id 
			redirect_to articles_path, notice: 'Logged in successfully!'
		else 
			flash[:error] = 'Invalid email or password'
			render :new, status: :unprocessable_entity, content_type: "text/html"
		end
	end
	
	def destroy 
		session[:user_id] = nil
		redirect_to root_path, notice: 'Logged out successfully!'
	end
end
