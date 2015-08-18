RSpec.configure do |config|
  config.color = true
  config.fail_fast = ENV['FAIL_FAST'] || false
  config.mock_with :rspec
  config.raise_errors_for_deprecations!
end

#
# Helpers
#

def fixture_subpath(subpath)
  Pathname(__dir__) + 'fixtures' + subpath
end
