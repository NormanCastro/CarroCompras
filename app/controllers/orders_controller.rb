class OrdersController < ApplicationController
	before_action :authenticate_user!
	before_action :set_cart, only: [:empty_cart, :index]

	def empty_cart
		@cart.destroy_all
		redirect_to orders_path, notice: 'Se ha vaciado el carro'

	end

	def index
		@orders = @cart

		@total = @orders.inject(0) {|total, order|total += order.product.price}

		@subtotal = @orders.inject(0) {|subtotal, order|subtotal += order.product.price * order.quantity}
	end

	def destroy
		@order = Order.find(params[:id])

		if @order.quantity == 1
			@order.destroy
			redirect_to orders_path, notice: 'El producto ha sido removido del carro'

		elsif @order.quantity > 1
			new_quantity = @order.quantity - 1
			@order.update(quantity: new_quantity)
			redirect_to orders_path, notice: 'Carro Actualizado'
			end		
		
	end

	def create
		@previous_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)

		if @previous_order.present?
			new_quantity = @previous_order.quantity + 1
			@previous_order.update(quantity: new_quantity)
			redirect_to root_path, notice: 'La orden se ha generado con exito'
		else
			@order = Order.new()
			@product = Product.find(params[:product_id])
			@order.product = @product
			@order.price = @product.price
			@order.user = current_user

		if @order.save
			redirect_to root_path, notice: 'El producto ha sido agregado al carro'
		else
			redirect_to root_path, alert: 'El producto no ha sido agregado al carro'	
		end
	end
  end	

  	private

  	def set_cart
  		@cart = current_user.cart
  		
  	end


end
