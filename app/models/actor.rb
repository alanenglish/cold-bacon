class Actor < ApplicationRecord
  has_many :roles
  has_many :top_movies, through: :roles, source: :movie
  has_many :paths, as: :traceable

  validates_presence_of :name, :image_url, :tmdb_id
  validates_uniqueness_of :name, :tmdb_id

  def self.random_qualified_starting_actors
    self.popular_actors.order("RANDOM()")
  end

  def self.popular_actors
    self.where("popularity > ?", self.minimum_popularity)
  end

  def get_top_movies
    unless top_movies.count == number_of_top_movies
      movies = known_for_movies(search_api_for_actor)
      movies.each do |movie|
        top_movie = Movie.find_or_create_by(name: movie["title"], tmdb_id: movie["id"], image_url: movie["poster_path"])
        Role.find_or_create_by(actor: self, movie: top_movie)
      end
    end
    top_movies
  end

  def search_api_for_actor
    search = Tmdb::Search.new
    search.resource("person")
    search.query(name)
    search.fetch
  end

  def known_for_movies(actor_object)
    actor_object.first["known_for"]
  end

  private
    def number_of_top_movies
      3
    end

    def self.minimum_popularity
      7.00
    end
end
