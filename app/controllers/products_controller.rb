class ProductsController < ApplicationController
  def index
	  	if params[:buscar].present?
	  		consulta = params[:buscar].capitalize
	  		@products = Product.where('name like?', "%#{consulta}%")

	  	else
	  	 	@products = Product.all
	  	end
 	end
end 

