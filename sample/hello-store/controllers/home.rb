class Home
  include WelltreatStoreFramework::Controller

  def index(request, response)
    response.set :title, "Hello World"
    response.set :name, "Hasan"

    response.set :products, app.models::Product.all
  end
end