class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    
    @movies = Movie.all.decorate
    
    hydra = Typhoeus::Hydra.new
    requests = @movies.pluck(:title).uniq.map { |title|
      request = Typhoeus::Request.new("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(title)}", followlocation: true)
      hydra.queue(request)
      request
    }
    hydra.run
    #raise requests.count.to_s
    @responses = {}
    requests.map { |request|
      @responses[eval(request.response.body)[:data][:attributes][:title]] = eval(request.response.body)[:data][:attributes]
      
    }
    #raise @responses.count.to_s
    #raise responses.to_yaml
    #https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(movie.title)}
    
    #require 'open-uri'
    #raise @movies.map{|m|  eval(open("https://pairguru-api.herokuapp.com/api/v1/movies/#{URI.encode(m.title)}").read)[:data]}.to_s
    #raise @movies.map{|m|  m}.to_s
    #response = open("https://pairguru-api.herokuapp.com/api/v1/movies/#m.title").read
    #raise @movies.to_yaml
  end

  def show
    #raise "user:#{current_user}"
    @movie = Movie.find(params[:id])
  end
  def delete_comment
    if current_user and movie = Movie.find(params[:id]) and comment = movie.comments.where(user: current_user).first
      comment.destroy
      redirect_back(fallback_location: root_path, notice: "comment deleted")
    else
      redirect_back(fallback_location: root_path, notice: "comment not deleted")
    end
  end
  def add_comment
    @movie = Movie.find(params[:id])
    #
    if current_user and @movie.comments.where(user: current_user).first
      redirect_back(fallback_location: root_path, notice:"Comment already added, first delete it")
    else
      @movie.comments.create(user: current_user, body: params[:comment][:body])
      redirect_back(fallback_location: root_path, notice:"Comment added")
      #raise params.to_yaml
    end
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
