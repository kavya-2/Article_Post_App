class CommentsController < ApplicationController
	# before_action :require_login, except: [:index, :show] 
	before_action :require_login, only: [:index, :show] 
	before_action :authorize_edit, only: [:edit, :update]
	
	def new
		@article = Article.find(params[:article_id])
		@comment = @article.comments.new
	end

	def create
		@article = Article.find(params[:article_id]) 
		@comment = @article.comments.build(comment_params) 
		@comment.user = current_user 
		if @comment.save 
			redirect_to @article, notice: 'Comment created successfully!'
		else 
			flash.now[:alert] = 'Comment could not be created!'
			render 'articles/show'
			# render :new, status: :unprocessable_entity
		end
	end
	
	def edit
		@article = Article.find(params[:article_id]) 
		@comment = @article.comments.find(params[:id]) 
		authorize_edit
		if current_user != @comment.user
			redirect_to @article, alert: 'You are not authorized to edit this comment!'
		end
	end
	
	def update
		@article = Article.find(params[:article_id]) 
		@comment = @article.comments.find(params[:id]) 
		# @comment.user = current_user 
		authorize_edit
		if current_user == @comment.user && @comment.update(comment_params)
			redirect_to @article, notice: 'Comment updated successfully!'
		else 
			flash.now[:alert] = 'Comment could not be updated!'
			render :edit
		end
	end
	
	private
	
	def comment_params 
		params
			.require(:comment)
			.permit(:content, :parent_id)
			.merge(article_id: params[:article_id])
	end

	def require_login
		unless current_user 
			flash[:error] = "You must be logged in to access this page." 
			redirect_to root_path 
		end
	end

	def authorize_edit
		# unless current_user == @comment.user 
		# 	redirect_to root_path, alert: 'You are not authorized to perform this action.'
		# end

		@article = Article.find(params[:article_id]) 
		@comment = @article.comments.find(params[:id]) 
		# @comment = current_user.articles.comments.find_by(id: params[:id]) 

		if @comment.nil?
			flash[:alert] = "Comment not found." 
			redirect_to root_path
		elsif @comment.user != current_user 
			flash[:alert] = "You are not authorized to edit this comment." 
			redirect_to root_path
		end
	end
end
