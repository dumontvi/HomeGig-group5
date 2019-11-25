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
        @newPost = current_user.posts.build
        @categories = Category.all
    end
    
    def create
        @newPost = current_user.posts.build(post_params)
        @newPost.save

        redirect_to '/offerings/'
    end

    def manage
        @gigs = current_user.posts
      end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id).merge(user_id: current_user.id)
    end
end
