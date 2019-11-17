class GigsController < ApplicationController
    def index
      @gigs = Gig.all
    end
    
    def new
      @gig = current_user.gigs.build
    end

    def create
      @gig = current_user.gigs.build(gig_params)

      @gig.save
      redirect_to @gig
    end

    def show
      @gig = Gig.find(params[:id])
    end

    def manage
      @gigs = current_user.gigs
    end

    private
    def gig_params
      params.require(:gig).permit(:title, :description, :price)
    end
end
