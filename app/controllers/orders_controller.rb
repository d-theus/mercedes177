class OrdersController < ApplicationController
  before_filter :require_admin, except: [:new]
  after_filter :mail_client

  def new
    fetch_positions
    @order = Order.new
  end

  def edit
    @order = Order.includes(:positions).find(params[:id])
  end

  def index
    @orders = Order.order('created_at DESC')
  end

  private

  def mail_client
    true
  end

  def order_params
    params.require(:order).permit(:first_name, :middle_name, :last_name, :phone, :email, :status, :shipping_info, :address)
  end

  def fetch_positions
    items = Item.order('RANDOM()').limit(5).reject { |i| i.count == 0}
    @positions = items.map do |item|
      pos = Position.new(count: rand(item.count - 1) + 1)
      pos.item = item
      pos
    end
  end
end
