user = ENV['OPSCODE_USER'] || ENV['USER']
log_level          :info
log_location       STDOUT
node_name          "#{user}"
cookbook_path      ["#{ENV['HOME']}/cookbooks"]
cookbook_copyright "Kyle Bader"
cookbook_license   "apachev2"
cookbook_email     "kyle.bader@gmail.com"
