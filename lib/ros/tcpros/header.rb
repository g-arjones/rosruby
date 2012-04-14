# ros/tcpros/message.rb
#
# License: BSD
#
# Copyright (C) 2012  Takashi Ogura <t.ogura@gmail.com>
#
module ROS::TCPROS

  ##
  # header of rorpc's protocol
  #
  class Header

    # rosrpc uses this wild card for cancel md5sum check or any.
    WILD_CARD = '*'

    def initialize
      @data = {}
    end

    # add key-value data to this header.
    # key and value must be string
    def push_data(key, value)
      @data[key] = value
      self
    end

    def get_data(key)
      @data[key]
    end

    alias_method :[]=, :push_data
    alias_method :[], :get_data

    # deserialize the data to header.
    # this does not contain total byte number.
    def deserialize(data)
      while data.length > 0
        len, data = data.unpack('Va*')
        msg = data[0..(len-1)]
        equal_position = msg.index('=')
        key = msg[0..(equal_position-1)]
        value = msg[(equal_position+1)..-1]
        @data[key] = value
        data = data[(len)..-1]
      end
      self
    end

    ##
    # validate the key with the value.
    # if it is WILD_CARD, it is ok!
    def valid?(key, value)
      (@data[key] == value) or value == WILD_CARD
    end

    # serialize the data into header
    # this contains total byte number because of convenient.
    def serialize(buff)
      serialized_data = ''
      @data.each_pair do |key, value|
        data_str = key + '=' + value
        serialized_data = serialized_data + [data_str.length, data_str].pack('Va*')
      end
      total_byte = serialized_data.length
      return buff.write([total_byte, serialized_data].pack('Va*'))
    end

  end
end