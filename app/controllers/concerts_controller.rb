class ConcertsController < ApplicationController
  def index
    @concerts = Concert.all
  end

  def refresh
  end
end
