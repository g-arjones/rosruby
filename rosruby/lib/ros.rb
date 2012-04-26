#  ros.rb
#
# License: BSD
#
# Copyright (C) 2012  Takashi Ogura <t.ogura@gmail.com>
#

#
# start up file.
# add rospackage paths to $:.
#

require 'ros/package'
ROS::load_manifest('rosruby')
["#{ENV['HOME']}/.ros/rosruby/msg_gen/ruby", "#{ENV['HOME']}/.ros/rosruby/srv_gen/ruby"].each do |path|
  if File.exists?(path)
    if not $:.include?(path)
      $:.push(path)
    end
  end
end
require 'ros/node'

# ensure shutdown all nodes
END {ROS::Node.shutdown_all_nodes}