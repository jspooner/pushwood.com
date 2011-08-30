class ArchiveController < ApplicationController
  def index
    @countries = Location.select("DISTINCT country").collect { |i| i.country }.compact!.sort
  end

  def country
    @country = params[:country].titleize
    @states = Location.select("DISTINCT state").where("country = ?", @country)
    @states = @states.collect { |i| i.state }
    @states.sort! unless @states.empty?
    @states.compact! unless @states.empty?
  end

  def state
    @country = params[:country].titleize    
    @state   = params[:state]
    @cities  = Location.select("DISTINCT city").where("state = ?", @state)
    @cities  = @cities.collect { |i| i.city }
    @cities.compact! unless @cities.empty?
    @cities.sort! unless @cities.empty?
    
    @locations = Location.near(@state)
  end

  def city
    @city = params[:city].titleize
    @locations = Location.near(@city)
  end

end
