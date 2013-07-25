module Toys
  module Containers
    # A Toys::Container class that returns an hash
    class Hash

      # @!attribute [r] default_model
      #   @return [Object] default model used if mk_array called with no options, defaults to 100
      # @!attribute [r] default_size
      #   @return [Fixnum] default size of array returned from mk_array, defaults to 10
      attr_reader :default_model, :default_size

      # creates a new instance of class with default values
      def initialize
        @default_model = [:symbol, 10000]
        @default_size = 10
      end

      # Sets default_values for object
      # @param [Array<Object>] model value to set default_model to
      # @param [Fixnum] size value to set default_size to
      # @raise [ArgumentError] if size is not a Fixnum
      # @return [void]
      def defaults(model, size)
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(Fixnum)
        @default_model = *model
        @default_size  = size
      end

      # generates an hash using keys from the first element of generators, and values from the last value,
      #   the two values may be the same, the hash will have a number of elements eq to the size
      # @param [::Array<#take>] generator only the first and last generators are used
      # @param [Fixnum] size size of array to fill
      # @raise [ArgumentError] if size is not a Fixnum
      # @return [::Array] array of results of generator
      def contains(*generators, size)
        size ||= default_size
        raise ArgumentError, "size is not a Fixnum" unless size.is_a?(Fixnum)
        size ||= @default_size
        keys = generators.first.take(size)
        values = generators.last.take(size)
        keys.zip(values).inject({}){|h,a| h[a.first] = a.last;h}
      end

    end
  end
end
Toy.register_container(:hash,Toys::Containers::Hash.new)
