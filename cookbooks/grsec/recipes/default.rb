#
# Cookbook Name:: grsec
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

group "nosock" do
  gid "5002"
end

group "nocsock" do
  gid "5003"
end

group "nossock" do
  gid "5004"
end

group "tpe" do
  gid "5005"
end