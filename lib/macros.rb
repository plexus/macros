require 'pathname'

require 'parser/current'
require 'unparser'

MAIN = self

module Macros

  NotFound = Module.new.freeze

  def self.parse(string)
    Parser::CurrentRuby.parse(string)
  end

  def self.require(path)
    @loader ||= Loader.new
    @loader.require(path)
  end
end

class Parser::AST::Node
  def inspect(indent=0)
    indented = "  " * indent
    sexp = "#{indented}s(:#{@type}"

    first_node_child = children.index do |child|
      child.is_a?(AST::Node) || child.is_a?(Array)
    end || children.count

    children.each_with_index do |child, idx|
      if child.is_a?(AST::Node) && idx >= first_node_child
        sexp << ",\n#{child.inspect(indent + 1)}"
      else
        sexp << ", #{child.inspect}"
      end
    end

    sexp << ")"

    sexp
  end
end

# module Kernel
#   alias system_require require
#   def require(name)
#     $LOAD_PATH.each do |p|
#       so_file = (Pathname(p) + "#{name}.so")
#       rb_file = (Pathname(p) + "#{name}.rb")

#       if so_file.file?
#         system_require(name)
#         break
#       end

#       if rb_file.file?
#         unless $".include? rb_file.to_s
#           Macros::Loader.new.load(rb_file)
# $" << rb_file.to_s
#         end
#       end
#     end
#   end
# end

require_relative 'macros/sexp'
require_relative 'macros/compiler'
require_relative 'macros/expander'
require_relative 'macros/loader'
