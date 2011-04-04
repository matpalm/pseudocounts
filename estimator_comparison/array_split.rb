class Array

  def split_randomly proportion
    first = []
    second = []
    each do |element|
      random_choice = (rand() < proportion) ? first : second
      random_choice << element
    end
    [ first, second ]
  end

end
