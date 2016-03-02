class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  # returns a sorted set of all available ratings
  def self.movie_ratings
    ratings = Movie.uniq.pluck(:rating)
    return ratings
  end

  # determines the order of the movie list
  def movie_order
    if params[:sort_by] == "title_header"
      @t_hilite = true
      session[:sort_by] = "title_header"
      return :title
    elsif params[:sort_by] == "release_date_header"
      @r_hilite = true
      session[:sort_by] = "release_date_header" 
      return :release_date
    else
      #@session[:sort_by] = "id" if session.has_key?(:sort_by)
      return :id # default order of movies
    end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = MoviesController.movie_ratings # available movie ratings
    
    if !params.has_key?(:ratings) || params[:ratings].size == @all_ratings.size
      @checked_boxes = @all_ratings 
      @movies = Movie.all.order(movie_order) # all movies are query
    else
      @checked_boxes = params[:ratings].keys
      @movies = Movie.all.where(rating: @checked_boxes).order(movie_order)
    
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort_by => session[:sort_by])
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
    redirect_to movies_path(:sort_by => session[:sort_by])
  end

end
