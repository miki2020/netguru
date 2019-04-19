class CommentsController < ApplicationController
  def new
    #render :inline "New comment"
  end
  def destroy
    #@new_comment.save
    
    #render :inline "creating comment"
  end  
  def index
    comments = Comment.all
    render :inline => "All comments: #{comments.pluck(:id,:body)}"
  end
  def create
    #@new_comment.save
    redirect_back(fallback_location: root_path)
    #render :inline "creating comment"
  end
  def update
    #render :inline "creating comment"
    redirect_back(fallback_location: root_path)
  end
end
