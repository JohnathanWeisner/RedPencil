class Product < ActiveRecord::Base
  has_paper_trail
  has_one :red_pencil_tag

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

  def price_stable?
    date_limit = (Time.now.to_date - 30)
    price_updated_at.to_date < date_limit || created_at == updated_at
  end

  def tag_sale_over?
    tag = red_pencil_tag
    tag && tag.started_at < (Time.now.to_date - 30)
  end

  def price_increased?
    previous_version.price < price
  end
end
