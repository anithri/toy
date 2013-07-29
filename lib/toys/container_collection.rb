require 'singleton'
module Toys
  module Containers
    class Tracker
      include Singleton
      attr_reader :name_map
      def initialize
        @name_map = {}
      end
      def register_names(container_names, klass)
        container_names.each{ |container| name_map[container] = klass }
      end
      def register_all(container)
        name_map.each_pair{ |name, klass| container.register_container(name, klass.new) }
      end
    end
  end

  class ContainerCollection
    attr_reader :container_list, :toy

    def initialize(toy, auto_discover)
      @container_list = {}
      @toy = toy
      do_auto_discover if auto_discover
    end

    def register_container(name, container, raise_on_redefine = false, opts = {})
      base_name = name.intern
      var_name  = "@#{name}".intern

      if raise_on_redefine && ok_to_define?(base_name, bang_name, var_name)
        raise StandardError, "Redefining Toys::Container named #{name}(#{container.inspect}"
      end
      container_list[name] = container
      toy.instance_variable_set(var_name, container)
      toy.define_singleton_method base_name do |*args|
        self.instance_variable_get(var_name).make(*args)
      end
      return true unless container.respond_to?(:extra_toy_methods)
      container.extra_toy_methods.each do |method_name|
        self.define_singleton_method method_name do |*args|
          self.instance_variable_get(var_name).send(method_name,*args)
        end
      end
      return true
    end

    def ok_to_define?(*names)
      return false if names.empty?
      names.map{|e| [e,e.to_s]}.each do |n|
        if n.last.start_with?("@")
          toy.instance_variable_defined?(n.first)
        else
          container_list.has_key?(n.first) || toy.respond_to?(n.first)
        end
      end.none?
    end

    def do_auto_discover
      Toys::Containers::Tracker.instance.register_all(self)
    end

  end
end
