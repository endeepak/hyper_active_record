require 'active_record'
require 'active_support/core_ext/module/delegation'

module HyperActiveRecord
  module QueryMethods
    APPLIED_SCOPE_MARKER = :':applied_scope:'

    def where(opts, *rest)
      return super unless opts.is_a?(Hash)
      return super if opts.delete(APPLIED_SCOPE_MARKER)
      relation = clone
      applied_scopes = []
      opts.each do |name, value|
        scope = scopes[name]
        next if not scope
        next if scope.arity <= 0 and value == false
        applied_scopes << name
        relation = relation.send(name, value)
      end
      opts.delete(*applied_scopes) if applied_scopes.present?
      relation.where(opts.merge(APPLIED_SCOPE_MARKER => true), rest)
    end
  end
end

ActiveRecord::Relation.send(:include, HyperActiveRecord::QueryMethods)