class Product < ActiveRecord::Base
  has_paper_trail

  def price_usd
    "$%.2f" % (self[:price]/100.0)
  end

  def price_change_threshold?
    previous_price = previous_version.price.to_f
    if previous_price > price
      percent = 100 - ((price / previous_price) * 100)
      return true if percent >= 5 && percent <=30
    end
    false
  end
end
