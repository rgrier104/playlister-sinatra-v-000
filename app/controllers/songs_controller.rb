class SongsController < ApplicationController

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    @artists = Artist.all
    @genres = Genre.all

    erb :'/songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])

    erb :'/songs/show'
  end

  post '/songs' do
    @song = Song.create(params["song"])
    artist = Artist.all.find do |artist|
      artist.slug == params[:artist][:name].downcase.gsub(' ','-')
    end
    if artist
      artist.songs << @song
    else
      @artist = Artist.create(name: params[:artist][:name])
      @artist.songs << @song
    end

    @params[:genres].each do |genre|
      @song.genres << genre
    end

    redirect to "/songs/#{@song.slug}"
  end

end
