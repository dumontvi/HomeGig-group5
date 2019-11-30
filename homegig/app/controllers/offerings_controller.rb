class OfferingsController < ApplicationController

    def index
        if params[:name].blank? 
            @posts = Post.all
            @posts = @posts.category(params[:categoryId]) if params[:categoryId].present?
        else  
            if params[:categoryId].present?
                @posts = Post.where(["LOWER(title) LIKE ? AND category_id = ?", "%#{params[:name].downcase}%", params[:categoryId]])   
            else
                @posts = Post.where(["LOWER(title) LIKE ?", "%#{params[:name].downcase}%"])
            end
        end 
        @current_category_id = params[:categoryId] if params[:categoryId].present?
        @categories = Category.all
    end

    def show
        @post = Post.find(params[:id])
        @reviews = @post.reviews
        @posts = Post.all.where("user_id":@post.user_id).where.not("title":@post.title)
    end

    def new
        @newPost = current_user.posts.build
        @categories = Category.all
    end
    
    def create
        @newPost = current_user.posts.build(post_params)
        @categories = Category.all
        if @newPost.save
            redirect_to '/offerings/'
        else
            if post_params[:title].size > 20 || post_params[:title].size < 5
                flash[:error] = "Error: The Post Title has to be in between 5 and 20 characters."
            end
            if post_params[:content].size < 10 ||  post_params[:content].size > 200
                flash[:error] = "Error: The Post Content has to be in between 10 and 200 characters"
            end
            redirect_to '/offerings/new'
        end
    end

    def manage
        @gigs = current_user.posts
      end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id).merge(user_id: current_user.id)
    end
end
