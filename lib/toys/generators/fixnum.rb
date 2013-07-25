module Toys
  module Generators
    # a Toys::Generators class that uses a model number to generate random numbers of the same magnitude
    class Fixnum < Base

      DEFAULT_MODEL = 10

      # returns a single fixnum at random from 1 to the max_value
      # the model is used to set the max_value.  the max_value is set to the next higher
      #   power of 10, unless that is only 10 in which case the max_value is 20.
      # @example max_values as a result of model value
      #   Toys::Generators::Fixnum.new(3).send(:max_value) #=> 20
      #   Toys::Generators::Fixnum.new(9).send(:max_value) #=> 20
      #   Toys::Generators::Fixnum.new(10).send(:max_value) #=> 20
      #   Toys::Generators::Fixnum.new(23).send(:max_value) #=> 100
      #   Toys::Generators::Fixnum.new(47).send(:max_value) #=> 100
      #   Toys::Generators::Fixnum.new(101).send(:max_value) #=> 1000
      #   Toys::Generators::Fixnum.new(13453).send(:max_value) #=> 100000
      # @return [Fixnum] random value
      def kick
        rng.rand(value_range)
      end

      private
      def min_value
        1
      end

      def scale
        10 ** Math.log10(@model).ceil.to_i
      end

      def max_value
        @max_value ||= [20,scale].max
      end

      def value_range
        min_value..max_value
      end
    end
  end
end
Toy.name_generator(:fixnum, Toys::Generators::Fixnum, false)
Toy.catcher_generator(Fixnum, Toys::Generators::Fixnum, false)