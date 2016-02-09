class ConcertsController < ApplicationController
  def index
    @concerts = Concert.all.order(:datetime)
  end
end
