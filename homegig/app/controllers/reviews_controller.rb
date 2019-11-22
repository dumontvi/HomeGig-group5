class ReviewsController < ApplicationController
    before_action :authenticate_user!
    after_action :create_notification, only: [:create]

    def new
        @review = Review.new
    end
    
    def create
        @review = Review.new(review_params)
        @review.save

        redirect_to '/offerings/posts/' + params[:id]
    end

    private
    def review_params
        params.require(:review).permit(:content).merge(user_id: current_user.id, post_id: params[:id])
    end

    def create_notification
        post = Post.find(params[:id])
        if post
            Notification.create(from_user: current_user,
                                to_user: post.user,
                                description: "#{current_user.email} has left you a review",
                                checked: false)
        end
    end
end
