class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    @movies = Movie.all.decorate
    #require 'open-uri'
    #raise @movies.map{|m|  eval(open("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(m.title)}").read)[:data]}.to_s
    #raise @movies.map{|m|  m}.to_s
    #response = open("https://pairguru-api.herokuapp.com/api/v1/movies/#m.title").read
    #raise @movies.to_yaml
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def send_info
    @movie = Movie.find(params[:id])
    MovieInfoMailer.send_info(current_user, @movie).deliver_later
    redirect_back(fallback_location: root_path, notice: "Email sent with movie info")
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.delay.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exporting"
  end
end
