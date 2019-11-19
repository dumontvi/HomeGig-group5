class OfferingsController < ApplicationController

    def index
        @categories = Category.all
        @posts = Post.all
    end

    def show
        @post = Post.find(params[:id])
        @reviews = @post.reviews
    end

end
