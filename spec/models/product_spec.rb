require 'rails_helper'

RSpec.describe Product, '.price_change_threshold?' do
  with_versioning do
    it 'should return false if price change is 4%' do
      product = create(:product)
      product.price = 96
      product.save
      expect(product.price_change_threshold?).to eq false
    end

    it 'should return true if price change is 5%' do
      product = create(:product)
      product.price = 95
      product.save
      expect(product.price_change_threshold?).to eq true
    end

    it 'should return true if price change is 15%' do
      product = create(:product)
      product.price = 85
      product.save
      expect(product.price_change_threshold?).to eq true
    end

    it 'should return true if price change is 30%' do
      product = create(:product)
      product.price = 70
      product.save
      expect(product.price_change_threshold?).to eq true
    end

    it 'should return false if price change is 31%' do
      product = create(:product)
      product.price = 69
      product.save
      expect(product.price_change_threshold?).to eq false
    end
  end
end

RSpec.describe Product, '.price_stable?' do
  with_versioning do
    it 'should return false if the price has just changed' do
      product = create(:product)
      product.price = 96
      product.save
      expect(product.price_stable?).to eq false
    end

    it 'should return false if the price changed 29 days ago' do
      product = create(:product)
      product.price = 96
      product.save
      product.updated_at = Time.now.to_date - 29
      expect(product.price_stable?).to eq false
    end

    it 'should return true if price has not changed' do
      product = create(:product)
      expect(product.price_stable?).to eq true
    end


    it 'should return true if price has only changed 31 days prior' do
      product = create(:product, {updated_at: (Time.now.to_date - 31) })
      expect(product.price_stable?).to eq true
    end
  end
end

RSpec.describe Product, '.tag_sale_over?' do
  with_versioning do
    it 'should return true if the sale lasted longer than 30 days' do
      product = create(:product, 
        {red_pencil_tag_started_at: (Time.now.to_date - 31) })
      expect(product.tag_sale_over?).to eq true
    end

    it 'should return false if the sale lasted only 1 day' do
      product = create(:product, 
        {red_pencil_tag_started_at: (Time.now.to_date - 1) })
      expect(product.tag_sale_over?).to eq false
    end

    it 'should return false if the sale lasted only 29 day' do
      product = create(:product, 
        {red_pencil_tag_started_at: (Time.now.to_date - 29) })
      expect(product.tag_sale_over?).to eq false
    end
  end
end