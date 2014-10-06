class Product < ActiveRecord::Base
  has_one :red_pencil_tag, dependent: :destroy
  before_save :red_tag_check!

  has_paper_trail

  def price_usd
    "$%.2f" % (self[:price]/100.0)
  end

  def price_change_threshold?
    prev_version = previous_version
    if prev_version
      previous_price = prev_version.price.to_f
      if previous_price > price
        percent = 100 - ((price / previous_price) * 100)
        return true if percent >= 5 && percent <=30
      end
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

  private

  def red_tag_check!
    create_red_pencil_tag(started_at: DateTime.now) if price_change_threshold?
  end
end
