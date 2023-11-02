class ArticlesController < ApplicationController
	# before_action :require_login, except: [:index, :show]
	before_action :require_login, only: [:show]  
	before_action :authorize_edit, only: [:edit, :update] 
	
	def index
		# debugger
		@articles = Article.all
		# @articles = Article.where(visibility: :public)
		# if current_user
		# 	@articles = Article.where(visibility: [:public, :draft], user: [current_user, nil])
		# 	@articles = Article.where(visibility: :public).or(Article.where(user: current_user, visibility: :draft))
		# else
		# 	@articles = Article.where(visibility: :public)
		# end
	end
	
	def show
		@article = Article.find(params[:id])
		@comment = Comment.new 
		@comment.user = current_user 
	end
	
	def new
		@article = current_user.articles.build
	end
	
	def create
		@article = current_user.articles.build(article_params)
		# debugger
		if params[:commit] == 'Create Article'
			@article.visibility = 'public'
		else
			@article.visibility = 'draft'
		end
	
		if @article.save
			redirect_to @article, notice: 'Article created successfully!'
		else
			render :new, status: :unprocessable_entity
		end
	end
	
	def edit
		@article = current_user.articles.find(params[:id]) 
	end

	def destroy
		@article = current_user.articles.find(params[:id]) 
		@article.destroy
		redirect_to @article, notice: 'Article deleted successfully!'
	end

	def update
		@article = current_user.articles.find(params[:id]) 
		if @article.update(article_params) 
			redirect_to @article, notice: 'Article updated successfully!'
		else 
			render :edit, status: :unprocessable_entity
		end
	end
	
	private
	
	def article_params 
		params.require(:article).permit(:title, :content, :visibility) 
		# params.require(:article).permit(:title, :content, :visibility)
		# 	.tap { |p| p[:visibility] = "draft" if params[:commit] == "Save Draft" }
	end

	def require_login
		unless current_user 
			flash[:error] = "You must be logged in to access this page." 
			redirect_to root_path 
		end
	end

	def authorize_edit
		@article = current_user.articles.find_by(id: params[:id]) 

		if @article.nil?
			flash[:alert] = "Article not found." 
			redirect_to root_path
		elsif @article.user != current_user 
			flash[:alert] = "You are not authorized to edit this article." 
			redirect_to root_path
		end
	end
end
