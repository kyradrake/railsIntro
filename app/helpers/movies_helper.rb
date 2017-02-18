module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def highlight_column(col)
    session[:sort_by] == col.to_s ? 'hilite' : nil
  end
end
