class OrdersController < ApplicationController
  before_filter :require_admin, except: [:new]
  after_filter :mail_client

  respond_to :html, :json

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    positions = JSON.parse(cookies[:'cart-positions'])
    positions.each { |p| @order.positions << Position.new(item_id: p['id'], count: p['count']) }
    if @order.save
      redirect_to orders_received_path(order_id: @order.id)
    else
      flash.now[:alert] = 'Ошибка при составлении заказа!'
      render :new
    end
  end

  def edit
    @order = Order.includes(:positions).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      flash.now[:notice] = "Статус заказа №#{@order.id} изменен на #{I18n.t 'order_status.'+@order.status}."
      redirect_to orders_path
    else
      flash.now[:alert] = 'Статус заказа не был изменен.'
      render :edit
    end

  end

  def index
    @orders = Order.order('created_at DESC').to_a.map do |ord|
      ord.status = I18n.t("order_status.#{ord.status}")
      ord
    end

    respond_to do |f|
      f.html
      f.json { respond_with @orders }
    end
  end

  def received
    @order_id = params[:order_id]
    render :received
  end

  private

  def mail_client
    true
  end

  def order_params
    params.require(:order).permit(:first_name, :middle_name, :last_name, :phone, :email, :status, :shipping_info, :address, :delivery_method, positions: [])
  end
end
