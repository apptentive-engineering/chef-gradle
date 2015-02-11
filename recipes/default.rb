#
# Cookbook Name:: apptentive_gradle
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Apptentive, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

download_url = "https://services.gradle.org/distributions/gradle-#{node["gradle"]["version"]}-bin.zip"
gradle_tgz   = "#{Chef::Config[:file_cache_path]}/#{File.basename(download_url)}"
version_path = "#{node["gradle"]["versions_dir"]}/#{node["gradle"]["version"]}"

package "bsdtar"

directory version_path do
  recursive true
  notifies :run, "execute[unpack gradle]"
end

remote_file gradle_tgz do
  source download_url
  notifies :run, "execute[unpack gradle]"
end

execute "unpack gradle" do
  command "bsdtar -xf #{gradle_tgz} -C #{version_path} --strip 1"
  action :nothing
end

link node["gradle"]["current_path"] do
  to version_path
end
