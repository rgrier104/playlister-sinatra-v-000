require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

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

  get '/songs/:slug/edit' do
    erb :'/songs/edit'
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

    params[:genres].each do |genre|
      @song.genres << Genre.find(genre)
    end
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  patch '/songs' do


    redirect to "/songs/#{@song.slug}"
  end
end
