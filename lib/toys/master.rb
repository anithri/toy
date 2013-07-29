module Toys
  class Master
    extend Forwardable

    attr_reader :containers

    def initialize(auto_discover = true)
      @containers = Toys::ContainerCollection.new(self, auto_discover)
      #@generators = Toys::Generator.new(self, auto_discover)
    end

    def_delegator :containers, :register_container
    #def_delegator :generators, :register_named_generator, :register_named
    #def_delegator :generators, :register_catch_generator, :register_catch
    #def_delegator :generators, :generator_from_model, :from
  end
end