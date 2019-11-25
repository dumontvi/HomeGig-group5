class SeekingsController < ApplicationController

    def index
        @categories = Category.all
        @posts = Spost.all
        @posts = @posts.category(params[:category]) if params[:category].present?
    end

    def show
        @post = Spost.find(params[:id])
    end

end
