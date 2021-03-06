class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # store sort_by in session
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    
    # store ratings in session
    if params[:ratings] 
      session[:ratings] = params[:ratings]
    end
    
    @all_ratings = Movie.pluck(:rating).uniq
    @ratings = session[:ratings] ? session[:ratings].keys : @all_ratings
    
    @movies = Movie.order(session[:sort_by]).where('rating IN (?)', @ratings)
    
    # if a user unchecks all checkboxes, use the settings stored in the session
    if !params[:ratings] && session[:ratings]
      flash.keep
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
