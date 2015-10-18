module Macros
  class Loader
    include Macros::Sexp

    def initialize
      @compiler = Macros::Compiler.new
      @macros   = {}
      @expander = Macros::Expander.new(@macros)
    end

    def require(name)
      $LOAD_PATH.each do |p|
        rb_file = (Pathname(p) + "#{name}.rb")

        if rb_file.file?
          unless $".include? rb_file.to_s
            load(rb_file)
            $" << rb_file.to_s
          end
        end
      end
    end

    def load(pathname)
      ast = Macros.parse pathname.read
      @macros.merge! @compiler.collect_defmacros(ast)
      rest_ast = @compiler.reject_defmacros(ast)
      MAIN.instance_eval Unparser.unparse @expander.macroexpand(rest_ast)
    end
  end
end
