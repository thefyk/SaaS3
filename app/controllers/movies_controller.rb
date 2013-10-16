class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
if params[:ratings].nil? && params[:order_field].nil?
 if !session[:order_field].nil? || !session[:ratings].nil?
    flash.keep
    redirect_to movies_path(:order_field=>session[:order_field], :ratings=>session[:ratings]) 
    return
 end
end

    if params[:order_field].nil?
    field = session[:order_field]
    else
    field = params[:order_field]
    session[:order_field] = params[:order_field]
  end

    @order_field = field


    @all_ratings = Movie.getratings


    if params[:ratings].nil?
      if session[:ratings].nil?
        @ratings1 = @all_ratings
      else
      @ratings1 = session[:ratings].keys
      @ratings = session[:ratings]
    end
    else
    session[:ratings] = params[:ratings]
    @ratings1 = params[:ratings].keys
    @ratings = params[:ratings]
  end


   @movies = Movie.where(:rating => @ratings1).order(field)

   
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
