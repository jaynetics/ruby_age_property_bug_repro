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

rx = /\p{age=99.0}/
test_str = (0..0xD7FF).map { |cp| cp.chr('utf-8') }.join <<
            (0xE000..0x10FFFF).map { |cp| cp.chr('utf-8') }.join
cps = (test_str.scan(rx).flat_map(&:codepoints) + (0xD800..0xDFFF).to_a).sort
cps2 = (test_str.scan(/\p{age=10.0}/).flat_map(&:codepoints) + (0xD800..0xDFFF).to_a).sort
puts cps.count, cps2.count

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('3.2.0')
  refute_support_prop('age=14.0') # <-- unexpected behavior on Ruby 2.x-3.0
else
  assert_support_prop('age=14.0')
end
