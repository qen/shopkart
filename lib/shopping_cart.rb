
class ShoppingCart

  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items         = []
  end

  def add(*args)
    args.each do |item|
      current_item = @items.select {|i| i.code == item.code }.first
      if current_item.nil?
        @items << item
      else
        current_item.qty += item.qty
      end
    end
  end

  def total
    @total ||= begin
      total = @items.map(&:subtotal).sum
      @pricing_rules.each {|rule| total = rule.total(@items, total) }
      total.round(2)
    end
  end

  def items
    # @pricing_rules.items(@items)
    @items.select {|item| item.type == 'product' }
    # @items
  end

  def bundles
    @items.select {|item| item.type == 'bundle' }
  end

  def discounts
    @items.select {|item| item.type == 'discount' }
  end

end
