class CartController < ApplicationController
  def refresh
    respond_to do |f|
      f.json { respond_with 'cart' }
    end
  end
end
