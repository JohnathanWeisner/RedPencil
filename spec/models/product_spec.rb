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