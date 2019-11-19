class ReviewsController < ApplicationController
    def new
        @review = Review.new
    end
    
    def create
        @review = Review.new(review_params)
        @review.save

        redirect_to '/offerings/' + params[:id]
    end

    private
    def review_params
        params.require(:review).permit(:content).merge(user_id: 1, post_id: params[:id])
    end
end
