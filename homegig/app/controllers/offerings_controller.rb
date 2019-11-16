class OfferingsController < ApplicationController

    def index
        @categories = Category.all
        @posts = Post.all
    end

end
