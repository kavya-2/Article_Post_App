class RepliesController < ApplicationController 
	before_action :set_comment, only: [:new, :create] 
	before_action :set_reply, only: [:edit, :update, :destroy] 
	
	def new
		@reply = @comment.replies.build 
	end
	
	def create
		@reply = @comment.replies.build(reply_params) 
		@reply.user = current_user 
		if @reply.save 
			redirect_to @comment.article, notice: 'Reply successfully created!'
		else 
			flash.now[:alert] = 'Reply could not be created!' 
			render :new
		end
	end
	
	def edit
		unless current_user == @reply.user 
			redirect_to @reply.comment.article, alert: 'You are not authorized to edit this reply!'
		end
	end
	
	def update
		if current_user == @reply.user && @reply.update(reply_params) 
			redirect_to @reply.comment.article, notice: 'Reply successfully updated!'
		else 
			flash.now[:alert] = 'Reply could not be updated!' 
			render :edit
		end
	end
	
	def destroy
		if current_user == @reply.user 
			@reply.destroy 
			redirect_to @reply.comment.article, notice: 'Reply successfully deleted!'
		else 
			redirect_to @reply.comment.article, alert: 'You are not authorized to delete this reply!'
		end
	end
	
	private
	
	def set_comment
		@comment = Comment.find(params[:comment_id]) 
	end
	
	def set_reply
		@reply = Reply.find(params[:id]) 
	end
	
	def reply_params 
		params.require(:reply).permit(:content) 
	end
end