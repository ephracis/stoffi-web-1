require 'spec_helper'

describe 'stoffi-web::web' do
  context 'When all attributes are default, on Ubuntu 14.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    # TODO: matcher seems to be missing
    # it 'updates apt cache' do
    #   expect(chef_run).to periodic_apt_update
    # end

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx')
    end

    it 'creates static html' do
      expect(chef_run).to create_directory('/var/www/stoffi.io/public_html')
        .with(user: 'www-data', group: 'www-data', mode: '0755')
      expect(chef_run).to(
        create_cookbook_file('/var/www/stoffi.io/public_html/index.html')
      )
    end

    it 'configures nginx' do
      expect(chef_run).to(
        create_template('/etc/nginx/sites-available/stoffi.io')
      )
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/stoffi.io')
      expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
      expect(chef_run).to delete_file('/etc/nginx/sites-available/default')
      expect(chef_run).to start_service('nginx')
      expect(chef_run).to enable_service('nginx')
      resource = chef_run.link('/etc/nginx/sites-enabled/stoffi.io')
      expect(resource).to notify('service[nginx]').to(:restart).delayed
    end
  end

  context 'When all attributes are default, on CentOS 7.2' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'centos', version: '7.2.1511'
      )
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'enables epel repo' do
      expect(chef_run).to include_recipe('yum-epel::default')
    end

    it 'installs nginx' do
      expect(chef_run).to install_package('nginx')
    end

    it 'creates static html' do
      expect(chef_run).to create_directory('/var/www/stoffi.io/public_html')
        .with(mode: '0755')
      expect(chef_run).to(
        create_cookbook_file('/var/www/stoffi.io/public_html/index.html')
      )
    end

    it 'configures nginx' do
      expect(chef_run).to(
        create_template('/etc/nginx/conf.d/stoffi.io.conf')
      )
      expect(chef_run).to start_service('nginx')
      expect(chef_run).to enable_service('nginx')
      resource = chef_run.template('/etc/nginx/conf.d/stoffi.io.conf')
      expect(resource).to notify('service[nginx]').to(:restart).delayed
    end
  end
end
