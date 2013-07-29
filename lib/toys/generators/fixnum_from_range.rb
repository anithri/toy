module Toys
  module Generators

    # takes a range as model, generates random number from range.
    # @example
    #   a = Toy.array_defaults(FixnumFromRange.new(80..120),4)
    #   a.mk_array #=> [103,87,99,111] Four elements of numbers between 80 and 120
    class FixnumFromRange < Base

      DEFAULT_MODEL = 1..20

      # @return [Fixnum] random number in range of @model
      def kick
        rng.rand(@model)
      end
    end
  end
end
Toys::MasterToy.instance.name_generator(:rand_range, Toys::Generators::FixnumFromRange)
