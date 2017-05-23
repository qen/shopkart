require 'byebug'
require 'shopping_cart'
require 'pricing_rules'
require 'items'

describe ShoppingCart do
  let(:ult_small) { Product.new 'ult_small', 'Unlimited 1GB', 24.90, 1 }
  let(:ult_medium) { Product.new 'ult_medium', 'Unlimited 2GB', 29.90, 1 }
  let(:ult_large) { Product.new 'ult_large', 'Unlimited 5GB', 44.90, 1 }
  let(:one_gig) { Product.new '1gb', '1 GB Data-pack', 9.90, 1 }
  let(:promo) { Promo.new 'I<3AMAYSIM', 'I<3AMAYSIM' }

  let(:bundle_rule) { BundleRule.new 'ult_small', 3, 1 }
  let(:discount_rule) { DiscountRule.new 'ult_large', 3, -5 }

  describe ".add" do
    context "multiple add of the same item" do
      let(:cart) do
        cart = ShoppingCart.new([])
        cart.add(ult_small, ult_small)
        cart
      end

      it "item count is 1" do
        expect(cart.items.size).to eq(1)
      end

      it "item qty is 2" do
        expect(cart.items.first.qty).to eq(2)
      end
    end
  end

  context "scenario 1" do

    let(:cart) do
      cart = ShoppingCart.new([bundle_rule])
      ult_small.qty = 3
      cart.add(ult_small, ult_large)
      cart.total
      cart
    end

    it "Expected Cart Total $94.70" do
      expect(cart.total).to eq(94.7)
    end

    it "Expected Cart Item: 3 x Unlimited 1 GB" do
      item = cart.items.select {|item| item.code == 'ult_small' }.first
      expect(item.qty).to eq(3)
    end

    it "Expected Cart Item: 1 x Unlimited 5 GB" do
      item = cart.items.select {|item| item.code == 'ult_large' }.first
      expect(item.qty).to eq(1)
    end

    it "Expects Bundle Item Modifier" do
      expect(cart.bundles.size).to eq(1)
    end

  end

  context "scenario 2" do

    let(:cart) do
      cart = ShoppingCart.new([discount_rule])
      ult_small.qty = 2
      ult_large.qty = 4
      cart.add(ult_small, ult_large)
      cart.total
      cart
    end

    it "Expected Cart Total $209.40" do
      expect(cart.total).to eq(209.40)
    end

    it "Expected Cart Item: 2 x Unlimited 1 GB" do
      item = cart.items.select {|item| item.code == 'ult_small' }.first
      expect(item.qty).to eq(2)
    end

    it "Expected Cart Item: 4 x Unlimited 5 GB" do
      item = cart.items.select {|item| item.code == 'ult_large' }.first
      expect(item.qty).to eq(4)
    end

    it "Expects Discount Item Modifier" do
      expect(cart.discounts.size).to eq(1)
    end


  end

  # describe ".add" do
  #   context "given an empty string" do
  #     it "returns type" do
  #       expect(Bundle.new.type).to eql('bundle')
  #     end
  #   end
  # end

end
