
Item = Struct.new(:code, :name, :price, :qty) do
  def type
    self.class.to_s.downcase
  end

  def subtotal
    return 0 if price.nil? or qty.nil?
    price * qty
  end
end

class Bundle < Item
end

class Product < Item
end

class Promo < Item
end

class Discount < Item
end

