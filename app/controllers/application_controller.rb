class ApplicationController < ActionController::Base
	helper_method :current_user, :logged_in?
	
	def ensure_current_user
		if current_user.nil?
			redirect_to "/"
		end
	end
	
	def current_user
		@current_user ||= User.find_by(id: session[:user_id]) if session[:user_id] 
	end
			
	def logged_in?
		!!current_user 
	end
end
