

class BundleRule

  def initialize(code, size, free_count = 1)
    @code = code
    @size = size
    @free_count = free_count
  end

  def total(items, current_total = 0)
    products = items.select {|item| item.type == 'product' and item.code == @code }

    current_bundle = items.select {|item| item.type == 'bundle' and item.code == @code }

    if not products.empty? and current_bundle.empty?
      values = products.first.values
      multiplier = products.map(&:qty).sum.to_i / @size
      bundle = Bundle.new *values
      bundle.qty = @free_count * multiplier
      bundle.price *= -1
      items << bundle
    end

    items.map(&:subtotal).sum
  end
end

class DiscountRule

  def initialize(code, size, discount = 0)
    @code = code
    @size = size
    @discount = discount
  end

  def total(items, current_total = 0)
    products = items.select {|item| item.type == 'product' and item.code == @code }

    current_discount = items.select {|item| item.type == 'discount' and item.code == @code }

    if not products.empty? and current_discount.empty? and ( products.map(&:qty).sum > @size )
      values = products.first.values
      discount = Discount.new *values
      discount.price = @discount
      items << discount
    end

    items.map(&:subtotal).sum
  end
end

class FreebieRule

  def initialize(code, size, item)
    @code = code
    @size = size
    @item = item
  end

  def total(items, current_total = 0)
    products = items.select {|item| item.type == 'product' and item.code == @code }

    current_freebies = items.select {|item| item.type == 'freebie' and item.code == @code }

    if not products.empty? and current_freebies.empty?
      values = @item.values
      multiplier = products.map(&:qty).sum.to_i / @size

      product = Product.new *values
      product.qty = multiplier
      items << product

      discount = Discount.new *values
      discount.qty = multiplier
      discount.price *= -1
      items << discount
    end

    items.map(&:subtotal).sum
  end

end

class PromoRule
  def initialize(code, discount)
    @code = code
    @discount = discount.to_i
  end

  def total(items, current_total = 0)
    current_promo = items.select {|item| item.type == 'promo' and item.code == @code }.first

    if not current_promo.nil?
      total_discount = (1.0 - (@discount / 100.0))
      discounted_total = current_total * (1.0 - (@discount / 100.0))

      current_promo.name = "#{@discount.to_i}% discount"
      current_promo.price = (discounted_total - current_total)
      current_promo.qty = 1
    end

    discounted_total
  end
end
