require 'rails_helper'

RSpec.describe Product do
  with_versioning do
    let(:product) { create :product }

    describe '#price_change_threshold?' do
      it 'returns false if price change is 4%' do
        product.price = 96
        product.save
        expect(product.price_change_threshold?).to be false
      end

      it 'returns true if price change is 5%' do
        product.price = 95
        product.save
        expect(product.price_change_threshold?).to be true
      end

      it 'returns true if price change is 15%' do
        product.price = 85
        product.save
        expect(product.price_change_threshold?).to be true
      end

      it 'returns true if price change is 30%' do
        product.price = 70
        product.save
        expect(product.price_change_threshold?).to be true
      end

      it 'returns false if price change is 31%' do
        product.price = 69
        product.save
        expect(product.price_change_threshold?).to be false
      end
    end

    describe '#price_stable?' do
      it 'returns false if the price has just changed' do
        product.price = 96
        product.save
        expect(product.price_stable?).to be false
      end

      it 'returns false if the price changed 29 days ago' do
        product.price = 96
        product.save
        product.price_updated_at = 29.days.ago
        expect(product.price_stable?).to be false
      end

      it 'returns true if price has not changed' do
        expect(product.price_stable?).to be true
      end

      it 'returns true if price has only changed 31 days prior' do
        product = create(:product, price_updated_at: 31.days.ago)
        expect(product.price_stable?).to be true
      end
    end

    describe '#tag_sale_over?' do
      it 'returns true if the sale lasted longer than 30 days' do
        product.create_red_pencil_tag(started_at: 31.days.ago)
        expect(product.tag_sale_over?).to be true
      end

      it 'returns false if the sale lasted only 1 day' do
        product.create_red_pencil_tag(started_at: 1.day.ago)
        expect(product.tag_sale_over?).to be false
      end

      it 'returns false if the sale lasted only 29 day' do
        product.create_red_pencil_tag(started_at: 29.days.ago)
        expect(product.tag_sale_over?).to be false
      end
    end

    describe '#price_increased?' do
      it 'returns true if price increased from 100 to 101' do
        product.price = 101
        product.save
        expect(product.price_increased?).to be true
      end

      it 'returns false if price decreased from 100 to 99' do
        product.price = 99
        product.save
        expect(product.price_increased?).to be false
      end
    end

    describe '#red_tag_check!' do
      it 'product receives #red_tag_check! before save' do
        expect(product).to receive(:red_tag_check!)
        product.save
      end

      it 'starts a new red tag sale when price decreases 5%-30%' do
        product.price_updated_at = 31.days.ago
        product.save
        product.price = 85
        product.save
        expect(product.red_pencil_tag).to_not be_nil
        expect(product.red_pencil_tag.ended_at).to be_nil
      end

      it 'does not start a new red tag sale when price drops more than 30%' do
        product.price_updated_at = 31.days.ago
        product.save
        product.price = 69
        product.save
        expect(product.red_pencil_tag).to be_nil
      end

      it 'does not start a new red tag sale if price was not stable 30 days' do
        product.price_updated_at = 29.days.ago
        product.save
        product.price = 85
        product.save
        
        expect(product.red_pencil_tag).to be_nil
      end
    end
  end
end
