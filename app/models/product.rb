class Product < ActiveRecord::Base
  def price
    "$%.2f" % (self[:price]/100.0)
  end
end
