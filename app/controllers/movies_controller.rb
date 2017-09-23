class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

   if params[:commit]
     session.delete(:ratings)
     if session[:sort]
       sort = session[:sort]
       session.delete(:sort)
       redirect_to(:action => "index", :sort => sort)
     else
       redirect_to(:action => "index")
     end
   end

    if params[:sort]
      sort = params[:sort]
    elsif session[:sort]
      sort = session[:sort]
      session.delete(:sort)
      if session[:ratings]
        @ratings = session[:ratings]
        session.delete(:ratings)
        redirect_to(:action => "index", :sort => sort, :ratings => @ratings)
      else
        redirect_to(:action => "index", :sort => sort)
      end
    end 

    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      session.delete(:ratings)
      if session[:sort]
        sort = session[:sort]
        session.delete(:sort)
        redirect_to(:action => "index", :sort => sort, :ratings => @ratings)
      else
        redirect_to(:action => "index", :ratings => @ratings)
      end
    end

    @all_ratings = []
    Movie.all.each do |movie|
      @all_ratings << movie.rating
    end
    @all_ratings.uniq!.sort!

    if sort == "title" 
      if @ratings
        @movies = []
        Movie.find(:all, :order => :title).each do |movie|
          if @ratings.has_key?(movie.rating)
            @movies << movie
          end
        end
      else
        @movies = Movie.find(:all, :order => :title)
      end
      @hilite = sort.to_sym 
    elsif sort == "release_date"
      if @ratings
        @movies =[]
        Movie.find(:all, :order => :release_date).each do |movie|
          if @ratings.has_key?(movie.rating)
            @movies << movie
          end
        end
      else
        @movies = Movie.find(:all, :order => :release_date)
      end
      @hilite = sort.to_sym 
    else
      if @ratings
        @movies = []
        Movie.all.each do |movie|
          if @ratings.has_key?(movie.rating)
            @movies << movie
          end
        end
      else
        @movies = Movie.all
      end
      @hilite = :none 
    end

    if params[:sort]
      session[:sort] = sort
    end

    if params[:ratings]
     session[:ratings] = @ratings
    end

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