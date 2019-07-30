module MyEnum
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def enum(definitions)
    end
  end
end
