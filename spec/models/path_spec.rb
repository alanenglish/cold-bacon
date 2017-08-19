require 'rails_helper'

RSpec.describe Path, type: :model do
  let(:actor1) { Actor.create!(name: "Bill Murray", tmdb_id: 1, image_url: "profile.jpg") }
  let(:actor2) { Actor.create!(name: "Jack", tmdb_id: 2, image_url: "jack.jpg") }

  context "has attributes that pass validation" do
    let(:movie) { Movie.create!(title: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }
    let(:game) { Game.create!(starting_actor: actor1, ending_actor: actor2) }

    it "is a Path object" do
      path = Path.create!(game_id: game.id, traceable: actor1)
      expect(path).to be_instance_of Path
    end

    it "has a game id" do
      path = Path.create!(game_id: game.id, traceable: actor1)
      expect(path.game_id).to eq Game.first.id
    end

    it "can have a actor and access the name" do
      path = Path.create!(game_id: game.id, traceable: actor1)
      expect(path.traceable.name).to eq "Bill Murray"
    end

    it "can have a Actor object" do
      path = Path.create!(game_id: game.id, traceable: actor1)
      expect(path.traceable).to be_instance_of Actor
    end

    it "can have a movie and access the tile" do
      path = Path.create!(game_id: game.id, traceable: movie)
      expect(path.traceable.title).to eq "The Rock"
    end

    it "can have a Movie object" do
      path = Path.create!(game_id: game.id, traceable: movie)
      expect(path.traceable).to be_instance_of Movie
    end

  end

  context "will not pass validations when attributes are not present or are not valid" do
    let(:movie) { Movie.create!(title: "The Rock", tmdb_id: 1, image_url: "profile.jpg") }
    let(:game) { Game.create!(starting_actor: actor1, ending_actor: actor2) }

    it "does not save when actor is invalid" do
      path = Path.new(game_id: game.id)
      expect(path.valid?).to be false
    end

    it "does not save when game is not present" do
      path = Path.new(traceable: movie)
      expect(path.valid?).to be false
    end

  end

end
