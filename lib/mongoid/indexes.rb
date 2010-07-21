# encoding: utf-8
module Mongoid #:nodoc
  module Indexes #:nodoc
    extend ActiveSupport::Concern
    included do
      cattr_accessor :indexed
      self.indexed = false
    end

    module ClassMethods #:nodoc
      # Add the default indexes to the root document if they do not already
      # exist. Currently this is only _type.
      def add_indexes
        if Mongoid.autocreate_indexes
          if hereditary && !indexed
            self._collection.create_index(:_type, :unique => false, :background => true)
            self.indexed = true
          end
        end
      end

      # Adds an index on the field specified. Options can be :unique => true or
      # :unique => false. It will default to the latter.
      def index(name, options = { :unique => false })
        if Mongoid.autocreate_indexes
          collection.create_index(name, options)
        end
      end
    end
  end
end
