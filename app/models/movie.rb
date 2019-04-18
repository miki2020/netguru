# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
      
    stack = []
    symbols = { '{' => '}', '[' => ']', '(' => ')' }
    record.title.each_char do |c|
        stack << c if symbols.key?(c)
        record.errors[:title] << "can't have mixed brackets" if symbols.key(c) && symbols.key(c) != stack.pop
    end
    if stack.empty? == false
        record.errors[:title] << "can't have unclosed brackets" 
    end
    record.errors[:title] << "can't have empty brackets" if not (record.title =~ /\(\s*\)|\[\s*\]|\{\s*\}/).nil?
  end
end
class Movie < ApplicationRecord
  belongs_to :genre
  #validate :title_unclosed_brackets,:title_empty_brackets
  #include ActiveModel::Validations
  validates_with TitleBracketsValidator
  
  
  def title_unclosed_brackets
    stack = []
    symbols = { '{' => '}', '[' => ']', '(' => ')' }
    title.each_char do |c|
        stack << c if symbols.key?(c)
        errors.add(:title, "can't have mixed brackets") if symbols.key(c) && symbols.key(c) != stack.pop
    end
    if stack.empty? == false
        errors.add(:title, "can't have unclosed brackets") 
    end
  end
  def title_empty_brackets
       errors.add(:title, "can't have empty brackets") if not (title =~ /\(\s*\)|\[\s*\]|\{\s*\}/).nil?
  end
end
