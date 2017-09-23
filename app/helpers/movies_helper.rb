module MoviesHelper

  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  # Returns class for column headers
  def hilight_helper(header_id)
    if header_id == @hilite 
      "hilite"
    else
      ""
    end
  end

  def ratings_helper(rating_id)
    if @ratings
      if @ratings.has_key?(rating_id)
        true
      else
        false
      end
    else
      false
    end
  end

end