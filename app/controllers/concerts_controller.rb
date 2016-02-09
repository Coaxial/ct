class ConcertsController < ApplicationController
  def index
    @concerts = Concert.all.order(:datetime).where({soldout: false})
  end
end
