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
        flash[:error] = []
        if @newPost.save
            redirect_to '/seekings/'
        else
            if post_params[:title].size > 20 || post_params[:title].size < 5
                flash[:error] << "The Post Title has to be in between 5 and 20 characters."
            end
            if post_params[:content].size < 10 ||  post_params[:content].size > 200
                flash[:error] << "The Post Content has to be in between 10 and 200 characters"
            end
            redirect_to '/seekings/new'
        end
    end

    def edit
        @post = Spost.find(params[:id])
        @categories = Category.all
    end

    def update
        post = Spost.find(params[:id])
        flash[:error] = []
        if current_user and post.user.id == current_user.id # Make sure user can modify this gig
            if post.update(post_params)
                flash[:edit_success] = "You have successfully edited your gig"
                redirect_to manage_path
            else
                if post_params[:title].size > 20 || post_params[:title].size < 5
                    flash[:error] << "The Post Title has to be in between 5 and 20 characters."
                end
                if post_params[:content].size < 10 ||  post_params[:content].size > 200
                    flash[:error] << "The Post Content has to be in between 10 and 200 characters"
                end
                redirect_to edit_seeking_path(post)
            end
        else
            flash[:error] << "You cannot edit this gig"
            redirect_to edit_seeking_path(post)
        end
    end

    def delete
        post = Spost.find(params[:id])
        if current_user and post.user.id == current_user.id # Make sure user can delete this gig
            if post.destroy
                flash[:delete_success] = "Gig successfully deleted"
            else
                flash[:error] = "An error occurred. Could not delete gig"
            end
        else
            flash[:error] = "You cannot delete this gig"
        end 
        redirect_to manage_path   
    end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id, :seek_gig_image).merge(user_id: current_user.id)
    end

end
