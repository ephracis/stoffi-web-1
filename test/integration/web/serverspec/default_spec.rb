require 'spec_helper'

describe service('nginx') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

if os[:family] == 'redhat'
  describe file('/etc/nginx/conf.d/stoffi.io.conf') do
    it { should exist }
  end
else
  describe file('/etc/nginx/sites-enabled/stoffi.io') do
    it { should exist }
    it { should be_symlink }
  end
end
