require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef-vault/test_fixtures'
at_exit { ChefSpec::Coverage.report! }
