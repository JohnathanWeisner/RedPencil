class Product < ActiveRecord::Base
  has_one :red_pencil_tag, dependent: :destroy
  before_save :red_tag_check!

  has_paper_trail

  def price_usd
    sprintf('$%.2f', price / 100.0)
  end

  def price_change_threshold?
    if previous_version &&
      (previous_price = previous_version.price.to_f) &&
      previous_price > price

      percent_change = 100 - (price / previous_price) * 100
      return true if percent_change >= 5 && percent_change <= 30
    end
    false
  end

  def price_stable?
    date_limit = 30.days.ago
    price_updated_at.to_date < date_limit || created_at == updated_at
  end

  def tag_sale_over?
    red_pencil_tag && red_pencil_tag.started_at < 30.days.ago
  end

  def price_increased?
    previous_version.price < price
  end

  private

  def red_tag_check!
    return unless price_change_threshold? && price_stable?
    create_red_pencil_tag(started_at: DateTime.now)
  end
end
