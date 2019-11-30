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
        
        if @newPost.save
            redirect_to '/seekings/'
        else
            if post_params[:title].size > 20 || post_params[:title].size < 5
                flash[:error] = "Error: The Post Title has to be in between 5 and 20 characters."
            end
            if post_params[:content].size < 10 ||  post_params[:content].size > 200
                flash[:error] = "Error: The Post Content has to be in between 10 and 200 characters"
            end
            redirect_to '/seekings/new'
        end
    end

    def get_seekings_by_name
        render index
    end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id).merge(user_id: current_user.id)
    end

end
