

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
      multiplier.times do
        bundle = Bundle.new *values
        bundle.qty = 1
        bundle.price *= -1
        items << bundle
      end
    end

    items.map(&:subtotal).sum
  end
end
