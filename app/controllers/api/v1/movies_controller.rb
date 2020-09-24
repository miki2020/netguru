
module Api
  module V1
    class MoviesController < ApplicationController

      def index
        movies = Movie.select(:id,:title).all
        render json: movies
      end

      def show
        movie = Movie.select(:id,:title).find(params[:id])
        render json: movie
      end
    end
  end
end