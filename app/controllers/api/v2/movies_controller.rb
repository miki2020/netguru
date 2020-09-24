module Api
  module V2
    class MoviesController < ApplicationController

      def index
        #out = []
        movies = Movie.select("movies.id, movies.title,movies.genre_id,genres.name AS genre_name,COUNT(movies.id) AS movies_count").joins(genre:[:movies]).group(['movies.id', 'genres.id']).all
        #genres = {}
        #Genre.includes(:movies).references(:movies).all.map{ |g| genres[g.id] = {name: g.name,movies_count: g.movies.size} }
        #render json: genres
        
        #movies.map do |movie| out << { id: movie.id, title: movie.title, genre: {id: movie.genre.id, name: movie.genre.name, movies_count: movie.genre.movies.size} } end
        render json: movies
      end

      def show
        movie = Movie.select("movies.id, movies.title,movies.genre_id,genres.name AS genre_name,COUNT(movies.id) AS movies_count").joins(genre:[:movies]).group(['movies.id', 'genres.id']).references(:genres).find(params[:id])
        #raise movie.genre.to_yaml
        render json: movie
      end

 
    end
  end
end