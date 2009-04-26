# wrapped in own class to not pollute activerecord...
class AssociatedScope
  attr_accessor :context, :name, :associated_scope_options
  
  def initialize(context, name)
    @context = context
    @name = name
    
    # fetch the nested named_scope options
    
  end
  
  # TODO: perhaps someday walk the associations to determine class here...
  def associated_class
    innermost(context).to_s.singularize.classify.constantize
  end
  
  def to_options_hash(options_for_associated_scope = [])
    @associated_scope_options = associated_class.send(name, options_for_associated_scope).proxy_options
    
    case associated_scope_options
    when Hash
      nest_scope(context, associated_scope_options)
    when Proc
      nest_scope(context, associated_scope_options.call(*options_for_associated_scope))
    end
  end
  
  def nest_scope(context, options)
    scope = {}
    [:include, :joins].each do |type|
      if options[type]
        scope[type] = generate_nested_hash(context, options[type])
      end
    end
    
    if options[:conditions]
      if options[:conditions].class == Array || options[:conditions].class == String
        scope[:conditions] = options[:conditions]
      else
        scope[:conditions] = generate_nested_hash(context, options[:conditions])
      end
    end
  
    if scope[:include].blank? && scope[:joins].blank?
      scope[:joins] = context
    end
  
    scope
  end
  
  def innermost(hash_or_value)
    if hash_or_value.class == Hash
      innermost(hash_or_value.values.first)
    else
      hash_or_value
    end
  end
  
  # generate_nested_hash(a, b)         => {a => b}
  # generate_nested_hash({a => aa}, b) => {a => {aa => b}}
  def generate_nested_hash(a,b)
    new_hash = {}
    if a.class == Hash
      new_hash[a.keys.first] = generate_nested_hash(a.values.first, b)
    else
      new_hash[a] = b
    end
    
    new_hash
  end
end

ActiveRecord::Base.class_eval do
  named_scope :with_associated_scope, lambda { |context, name, *options|
    AssociatedScope.new(context, name).to_options_hash(*options)
  }
end