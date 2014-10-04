class Product < ActiveRecord::Base
  has_paper_trail
  
  def price
    "$%.2f" % (self[:price]/100.0)
  end
end
