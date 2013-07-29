module Toys
  module Containers
    # A Toys::Containers class that returns a single value
    class Value

      # @!attribute [r] default_model
      #   @return [Object] default model used if mk_array called with no options, defaults to 100
      attr_accessor :default_model

      # Sets default_values for object
      # @param [Object] model value to set default_model to
      # @return [void]
      def defaults(model)
        default_model = model
      end

      # creates a new instance of class with default values
      def initialize
        @default_model = "Hello"
      end

      # generates an array containing size elements of generator output
      # @param [#kick] generator generator used to generate value
      # @param [Object] size is ignored, present to ensure compliance with implied Toys::Containers interface
      # @return [Array<Generated>] Array of results of generator
      def contains(generator,size)
        generators.kick
      end

      # @returns [Fixnum] always returns 1, present to ensure compliance with implied Toys::Containers interface
      def default_size
        1
      end

    end
  end
end
Toys::MasterToy.instance.register_container(:value,Toys::Containers::Value.new)

