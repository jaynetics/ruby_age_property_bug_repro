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
assert_support_prop('age=10.0')
refute_support_prop('age=15.0')

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('3.2.0')
  refute_support_prop('age=14.0') # <-- unexpected behavior on Ruby 2.x-3.0
else
  9999.downto(16).each { |n| refute_support_prop("age=#{n}.0") }
  assert_support_prop('age=14.0')
end
