class SeekingsController < ApplicationController

    def index
        @categories = Category.all
        @posts = Spost.all
        @posts = @posts.category(params[:category]) if params[:category].present?
    end

    def show
        @post = Spost.find(params[:id])
    end

    def new
        @newPost = Spost.new
        @categories = Category.all
    end

    def create
        @newPost =Spost.new(post_params)
        @newPost.save

        redirect_to '/seekings/'
    end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id).merge(user_id: current_user.id)
    end

end
