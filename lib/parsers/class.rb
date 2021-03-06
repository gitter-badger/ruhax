module Ruhax
  class ClassParser < MasterParser
    def initialize(node)
      @node = node
      @options = {
        current_class: nil,
        instance_variables: [],
        class_variables: []
      }

      @inherit = ""
      @content = ""
    end

    def parse
      if @node.children.length == 0
        return
      end

      @node.children.each do |child|
        # Class metadata (name and inheritance)
        if child.is_a?(AST::Node) && child.type == :const
          child.children.each do |c|
            if c.is_a?(Symbol)
              if @options[:current_class] == nil
                @options[:current_class] = c.to_s
              else
                @inherit = c.to_s
              end
            end
          end
        elsif child.is_a?(AST::Node)
          @content << parse_new_node(child, @options).to_s
        end
      end
    end

    def to_s
      data = "class " << @options[:current_class]
      if @inherit.length > 0
        data << " < " << @inherit
      end
      data << "{\n"

      @options[:instance_variables].each do |v|
        data << "public var " << v << ";\n"
      end

      @options[:class_variables].each do |v|
        data << "public static var " << v << ";\n"
      end

      data << @content

      data << "\n}"
    end
  end
end
