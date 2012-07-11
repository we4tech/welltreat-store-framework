class Home
  include WelltreatStoreFramework::Controller

  def index(request, response, options = {})
    response.set :title, "Hello World"
    response.set :name, "Hasan"

    response.set :products, app.models::Product.all
  end

  def not_found(request, response, options = {})
    response.content = "<h1>Page Not found</h1>"
    response.status = 404
  end
end