class Cookie
  attr_accessor :sugar, :flour

  def info
    puts "The cookie has #{sugar}g of sugar and #{flour}g of flour"
  end

  def set_all(new_sugar_amount, new_flour_amount)
    self.sugar = new_sugar_amount
    self.flour = new_flour_amount
  end

end
