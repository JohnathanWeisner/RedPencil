require 'rails_helper'

RSpec.describe Product do
  with_versioning do
    let(:product) { create :product }

    describe '.price_change_threshold?' do
      it 'should return false if price change is 4%' do
        product.price = 96
        product.save
        expect(product.price_change_threshold?).to eq false
      end

      it 'should return true if price change is 5%' do
        product.price = 95
        product.save
        expect(product.price_change_threshold?).to eq true
      end

      it 'should return true if price change is 15%' do
        product.price = 85
        product.save
        expect(product.price_change_threshold?).to eq true
      end

      it 'should return true if price change is 30%' do
        product.price = 70
        product.save
        expect(product.price_change_threshold?).to eq true
      end

      it 'should return false if price change is 31%' do
        product.price = 69
        product.save
        expect(product.price_change_threshold?).to eq false
      end
    end

    describe '.price_stable?' do
      it 'should return false if the price has just changed' do
        product.price = 96
        product.save
        expect(product.price_stable?).to eq false
      end

      it 'should return false if the price changed 29 days ago' do
        product.price = 96
        product.save
        product.price_updated_at = Time.now.to_date - 29
        expect(product.price_stable?).to eq false
      end

      it 'should return true if price has not changed' do
        expect(product.price_stable?).to eq true
      end

      it 'should return true if price has only changed 31 days prior' do
        product = create(:product, {price_updated_at: (Time.now.to_date - 31) })
        expect(product.price_stable?).to eq true
      end
    end

    describe '.tag_sale_over?' do
      it 'should return true if the sale lasted longer than 30 days' do
        product.create_red_pencil_tag(
          started_at: (Time.now.to_date - 31))
        expect(product.tag_sale_over?).to eq true
      end

      it 'should return false if the sale lasted only 1 day' do
        product.create_red_pencil_tag(
          started_at: (Time.now.to_date - 1))
        expect(product.tag_sale_over?).to eq false
      end

      it 'should return false if the sale lasted only 29 day' do
        product.create_red_pencil_tag(
          started_at: (Time.now.to_date - 29))
        expect(product.tag_sale_over?).to eq false
      end
    end

    describe '.price_increased?' do
      it 'should return true if price increase from 100 to 101' do
        product.price = 101
        product.save
        expect(product.price_increased?).to eq true
      end

      it 'should return false if price decreased from 100 to 99' do
        product.price = 99
        product.save
        expect(product.price_increased?).to eq false
      end
    end
  end
end
