module Kaminari
  module PageScopeMethods
    def with_total_count(number = nil)
      @total_count = number if !number.nil?
      where(nil)
    end
  end
end
