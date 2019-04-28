class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  def self.best_commentators
    
    #).joins(genre:[:movies]).group(['movies.id', 'genres.id'])
    select("users.name ,COUNT(users.id) AS comments_count, users.id").joins(:user).group('users.id').where("comments.created_at > ?", (Time.now-7.days)).order("COUNT(users.id) DESC").limit(10)
  
  end
end
