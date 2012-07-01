class Product
  include FlexiModel

  flexi_field :name, :string
  flexi_field :description, :text
  flexi_field :price, :float
  flexi_field :available, :boolean

end