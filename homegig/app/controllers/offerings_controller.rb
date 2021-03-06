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

        if params[:filter].present?
            if params[:filter] == 'price_asc'
                @posts = @posts.order(:price)
                @selected_filter = ['Lowest to Highest Price', 'price_asc']
            elsif params[:filter] == 'price_desc'
                @posts = @posts.order(price: :desc)
                @selected_filter = ['Highest to Lowest Price', 'price_desc']
            elsif params[:filter] == 'date'
                @posts = @posts.order(created_at: :desc)
                @selected_filter = ['Most Recent First', 'date']
            end
        else
            @posts = @posts.order(created_at: :desc)
            @selected_filter = ['Most Recent First', 'date']
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
        flash[:error] = []
        if @newPost.save
            redirect_to '/offerings/'
        else
            if post_params[:title].size > 20 || post_params[:title].size < 5
                flash[:error] << "The Post Title has to be in between 5 and 20 characters."
            end
            if post_params[:content].size < 10 ||  post_params[:content].size > 200
                flash[:error] << "The Post Content has to be in between 10 and 200 characters"
            end
            redirect_to '/offerings/new'
        end
    end

    def manage
        @posts = current_user.posts
        @sposts = current_user.sposts
    end

    def edit
        @post = Post.find(params[:id])
        @categories = Category.all
    end

    def update
        post = Post.find(params[:id])
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
                redirect_to edit_offering_path(post)
            end
        else
            flash[:error] << "You cannot edit this gig"
            redirect_to edit_offering_path(post)
        end
    end

    def delete
        post = Post.find(params[:id])
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

    def search
        name = params[:name]
        if params[:name].blank? 
            redirect_to offeringAll_path(name: name)
        else  
            @posts = Post.where(["LOWER(title) LIKE ?", "%#{params[:name].downcase}%"])
            if @posts.empty?
                @posts = Spost.where(["LOWER(title) LIKE ?", "%#{params[:name].downcase}%"])
                if @posts.empty?
                    redirect_to offeringAll_path(name: name)
                else
                    redirect_to seekingAll_path(name: name)
                end
            else
                redirect_to offeringAll_path(name: name)
            end
        end 
    end

    private
    def post_params
        params.require(:post).permit(:title, :content, :price, :category_id, :gig_image).merge(user_id: current_user.id)
    end
end
