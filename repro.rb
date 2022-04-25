def support_prop?(prop)
  Regexp.new("/\\p{#{prop}}/") rescue false
end

def assert_support_prop(prop)
  support_prop?(prop) || raise("ruby #{RUBY_VERSION} should support #{prop}")
end

def refute_support_prop(prop)
  support_prop?(prop) && raise("ruby #{RUBY_VERSION} should NOT support #{prop}")
end

# some sanity checks
assert_support_prop('ascii')
refute_support_prop('non-existent-prop')

assert_support_prop('sterm')
