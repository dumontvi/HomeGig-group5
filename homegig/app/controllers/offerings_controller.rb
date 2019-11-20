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

end
