require 'spec_helper'

describe 'stoffi-web::default' do
  context 'When all attributes are default, on an unspecified platform' do
    # include ChefVault::TestFixtures.rspec_shared_context

    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
