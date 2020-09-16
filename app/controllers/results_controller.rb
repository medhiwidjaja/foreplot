class ResultsController < ApplicationController
  include TurbolinksCacheControl
  include ResultsConcern

  def index
    respond_to do |format|
      format.html 
      format.json
    end
  end

  def chart 
  end


end
