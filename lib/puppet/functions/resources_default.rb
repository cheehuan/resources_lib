# resource resources_default
Puppet::Functions.create_function(:resources_default, Puppet::Functions::InternalFunction) do
  dispatch :resources_default do
    scope_param
    param 'Hash', :resources_default_data
    optional_param 'Array', :resources_type
  end

  def resources_default(scope, resources_default_data = {}, resources_type = [])
    scope.setvar('resources_default_data', resources_default_data)
    scope.setvar('resources_type', resources_type)

    def scope.lookupdefaults(type)
      values = super(type)
      resources_default_data = lookupvar('resources_default_data')
      resources_type = lookupvar('resources_type')

      # Create a new :resources_default parameter with the specified value for our defaults hash
      if resources_type.empty? || resources_type.include?(values['name'])
        resources_default_data.each do |k, v|
          resources_default = Puppet::Parser::Resource::Param.new(
            name: k.to_sym,
            value: v,
            source: source,
          )
          # Adding this default fixes a corner case with resource collectors
          @defaults[type][k.to_sym] = resources_default
          # Replace whatever defaults we recieved
          values[k.to_sym] = resources_default
        end
      end
      values
    end
  end
end
