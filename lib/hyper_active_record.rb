require 'active_record'
require 'active_support/core_ext/module/delegation'

module HyperActiveRecord
  module QueryMethods

    def where(opts, *rest)
      return super unless opts.is_a?(Hash)
      return super if opts.delete(:':applied_scope:')
      relation = clone
      applied_scopes = []
      opts.each do |name, value|
        next if not scopes.has_key?(name)
        applied_scopes << name
        relation = relation.send(name, value)
      end
      opts.delete(*applied_scopes)
      relation.where(opts.merge(:':applied_scope:' => true), rest)
    end
  end
end

ActiveRecord::Relation.send(:include, HyperActiveRecord::QueryMethods)