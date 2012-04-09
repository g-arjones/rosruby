require 'ros/parameter_manager'
require 'ros/name'
require 'ros/topic_manager'
require 'ros/publisher'
require 'ros/subscriber'

module ROS
  class Node
    include Name

    def initialize(node_name)
      @node_name = resolve_name(node_name)
      @manager = TopicManager.new(@node_name)
      @parameter = ParameterManager.new(@node_name)
    end

    def resolve_name(name)
      resolve_name_with_call_id(@node_name, name)
    end

    def get_param(key)
      @parameter.get_param(resolve_name(key))
    end

    def set_param(key, value)
      @parameter.set_param(resolve_name(key), value)
    end

    def advertise(topic_name, topic_type)
      @manager.add_publisher(Publisher.new(@node_name, topic_name, topic_type))
    end

    def subscribe(topic_name, topic_type, callback)
      @manager.add_subscriber(Subscriber.new(@node_name,
                                             topic_name,
                                             topic_type,
                                             callback))
    end

    def spin_once
      @manager.spin_once
    end

    def shutdown
      @manager.shutdown
    end
  end
end
