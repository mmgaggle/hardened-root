#
# Cookbook Name:: timezone
# Recipe:: default
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

execute "UTC" do
  command "echo UTC > /etc/timezone"
  action :nothing
end

cookbook_file "/etc/timezone" do
  source "/usr/share/zoneinfo/UTC"
  owner "root"
  group "root"
  mode "0644"
  notifies :run, resources(:execute => "UTC")
end

cookbook_file "/etc/conf.d/hwclock" do 
  owner "root"
  group "root"
  mode "0644"
end 
