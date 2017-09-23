class Movie < ActiveRecord::Base

  def self.re_order(para)
    self.order(para)
  end

  def self.get_ratings
    rating_arr = Array.new
    movies = Movie.all
    movies.each do |movie|
       rating_arr.push movie[:rating]
       rating_arr.uniq!
    end
    return rating_arr
  end
end