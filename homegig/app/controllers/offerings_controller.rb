class OfferingsController < ApplicationController

    def index
        @categories = Category.all
        @posts = Post.all
        @posts = @posts.category(params[:category]) if params[:category].present?
    end

    def show
        @post = Post.find(params[:id])
        @reviews = @post.reviews
    end

    def new
        @newPost = Post.new
    end
    
    def create
        @newPost = Post.new(post_params)
        @newPost.save

        redirect_to '/offerings/'
    end

    private
    def post_params
        params.require(:post).permit(:content).merge(user_id: current_user.id, post_id: params[:id])
    end
end
