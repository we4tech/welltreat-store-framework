class Products
  include WelltreatStoreFramework::Controller

  class ProductNotFound < StandardError; end

  def index(request, response)
    response.set :products, [{name: 'Product 1'}, {name: 'Product 2'}]
  end

  def show(request, response)
    if request[:id].present?
      response.set :product, app.models::Product.find(request[:id])
      response.set :title, response.get(:product).name
    else
      raise ProductNotFound
    end
  end
end