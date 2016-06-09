class MyClass

  [:a, :b, :c, :d, :e, :f].each do |letter|
    define_method("find_by_#{letter}") do
      puts "I'm inside method #{letter}"
    end
  end

  def method_missing(*args)
    # if ..
      puts "I'm inside method missing #{args}"
    # else
      # raise NameError, "undefined method #{args[0]}"
    # end
  end

end
