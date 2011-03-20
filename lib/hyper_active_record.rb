require 'active_record'
require 'active_support/core_ext/module/delegation'

module HyperActiveRecord
  module QueryMethods
    APPLIED_SCOPE_MARKER = :':applied_scope:'

    def where(opts, *rest)
      return super unless opts.is_a?(Hash)
      return super if opts.delete(APPLIED_SCOPE_MARKER)

      scope_options, other_options = slice_scopes(opts)
      relation = self.scoped_by(scope_options)

      relation.where(other_options.merge(APPLIED_SCOPE_MARKER => true), rest)
    end

    def scoped_by(opts)
      opts.inject(clone) do |relation, scope|
        name , value = *scope
        relation = relation.send(name, value)
      end
    end

  protected
    def slice_scopes(opts)
      scope_options = {}
      opts.each do |name, value|
        scope = scopes[name]
        next if scope.nil?
        next if scope.arity <= 0 and value == false
        scope_options[name] = value
      end
      return scope_options, opts.except(*(scope_options.keys))
    end
  end
end

ActiveRecord::Relation.send(:include, HyperActiveRecord::QueryMethods)