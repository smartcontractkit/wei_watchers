def hashie(hash)
  Hashie::Mash.new hash
end

def factory_create(factory_name, options = {})
  FactoryGirl.create(factory_name, options)
end

def factory_build(factory_name, options = {})
  FactoryGirl.build(factory_name, options)
end
