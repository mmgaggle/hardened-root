#
# Cookbook Name:: djbdns
# Recipe:: dnscache
#
# Copyright 2013, Kyle Bader
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "daemontools"
include_recipe "djbdns::default"

dirs = %w{
  /service/dnscachex
  /service/dnscachex/env
  /service/dnscachex/root
  /service/dnscachex/root/servers
  /service/dnscachex/root/ip
  /service/dnscachex/log
  /service/dnscachex/log/main
  /service/dnscachex/log/supervise
  /service/dnscache/supervise
}

dirs.each do |dir|
  directory dir do
    group "root"
    mode "0755"
    action :create
  end
end

file "/service/dnscachex/env/CACHESIZE" do
  contents "1000000"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "/service/dnscachex/env/DATALIMIT" do
  contents "3000000"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "/service/dnscachex/env/IP" do
  contents "127.0.0.1"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "/service/dnscache/env/IPSEND" do
  contents "0.0.0.0"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "/service/dnscache/env/ROOT" do
  contents "/service/dnscachex/root"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

cookbook_file "/service/dnscachex/root/servers/@" do
  source "/etc/dnsroots.global"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

file "/service/dnscachex/root/ip/127.0.0.1" do
  action :touch
end

file "/service/dnscache/root/ip/#{node['ip_address']}" do
  action :touch
end
