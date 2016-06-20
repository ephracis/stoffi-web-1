apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
  only_if { node['platform_family'] == 'debian' }
end

%(rhel).include?(node['platform_family']) && \
  include_recipe('yum-epel::default')

package 'nginx'

directory '/var/www/stoffi.io/public_html' do
  if node['platform_family'] == 'debian'
    owner 'www-data'
    group 'www-data'
  end
  mode '0755'
  recursive true
  action :create
end

cookbook_file '/var/www/stoffi.io/public_html/index.html'

if node['platform_family'] == 'rhel'
  template '/etc/nginx/conf.d/stoffi.io.conf' do
    source 'nginx-site.erb'
    notifies :restart, 'service[nginx]', :delayed
  end
else
  template '/etc/nginx/sites-available/stoffi.io' do
    source 'nginx-site.erb'
  end

  link '/etc/nginx/sites-enabled/stoffi.io' do
    to '/etc/nginx/sites-available/stoffi.io'
    notifies :restart, 'service[nginx]', :delayed
  end

  link '/etc/nginx/sites-enabled/default' do
    action :delete
  end

  file '/etc/nginx/sites-available/default' do
    action :delete
    notifies :restart, 'service[nginx]', :delayed
  end
end

service 'nginx' do
  action [:start, :enable]
end
