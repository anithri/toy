require "toys/version"
require 'forwardable'

module Toys
  require 'toys/generator'
  require 'toys/generators/base'
  require 'toys/container_collection'
  require 'toys/containers/base'
  require 'toys/master'

  def mk_toy(auto_discover = true)
    Toys::Master.new(auto_discover)
  end

end

#Toy = Toys::Master.new
require 'toys/generators/fixnum'
#require 'toys/generators/string'
#require 'toys/generators/symbol'
#require 'toys/generators/fixnum_from_range'

require 'toys/containers/array'
#require 'toys/containers/hash'
#require 'toys/containers/value'

