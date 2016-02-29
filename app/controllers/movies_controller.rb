class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def self.movie_ratings
    movies = Movie.all
    ratings = SortedSet.new # unique ratings
    movies.each do |movie| # extract the rating
    ratings.add?(movie.rating)
    end
    return ratings
  end
=begin
  def movie_order
    if params[:sort_by] == "title_header"
      @t_hilite = true
      return :title
    elsif params[:sort_by] == "release_date_header"
      @r_hilite = true
      return :release_date
    else
      return :id # default order of movies
    end
  end
=end
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = MoviesController.movie_ratings # available movie ratings
    if params[:sort_by] == "title_header"
      @movies = Movie.all.order(:title)
      @t_hilite = true  # title highlight 
    elsif params[:sort_by] == "release_date_header"
      @movies = Movie.all.order(:release_date)
      @r_hilite = true #release date highlight
    else
      @movies = Movie.all
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
