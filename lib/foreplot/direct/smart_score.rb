module Foreplot
  module Direct

    class SmartScore

      def self.score(values, **options)
        min = options[:range_min] || values.min
        max = options[:range_max] || values.max
        range = max - min

        values.map do |value|
          score = begin
            if options[:minimize]
              (max - value.to_f) / range 
            elsif options[:range_min]
              (value.to_f - min) / range 
            else
              value.to_f
            end
          rescue 
            Float::NAN
          end
        end          
      end

    end
  end
end 
