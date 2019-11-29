class SeekingsController < ApplicationController

    def index
        if params[:name].blank? 
            @posts = Spost.all
            @posts = @posts.category(params[:categoryId]) if params[:categoryId].present?
        else  
            if params[:categoryId].present?
                @posts = Spost.where(["LOWER(title) LIKE ? AND category_id = ?", "%#{params[:name].downcase}%", params[:categoryId]])   
            else
                @posts = Spost.where(["LOWER(title) LIKE ?", "%#{params[:name].downcase}%"])
            end
        end 
        @current_category_id = params[:categoryId] if params[:categoryId].present?
        @categories = Category.all
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

    def get_seekings_by_name
        render index
    end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id).merge(user_id: current_user.id)
    end

end
