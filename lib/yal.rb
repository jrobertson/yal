#!/usr/bin/env ruby

# file: yal.rb

# description: Yet Another Logger (YAL) logs debug and info messages 
#              using a simple UDPSocket while logging error and fatal 
#              messages using the spspublog_drb_client gem.

require 'socket'
require 'spspublog_drb_client'



class Yal

  class UDPlog

    def initialize(address='127.0.0.1', port=1024, topic='udplog', 
                    maxcharlength=280, subtopic: '')

      @u = UDPSocket.new
      @address, @port, @topic, @subtopic = address, port, topic, subtopic
      @maxcharlength = maxcharlength
    
    end

    def debug(s)
      log_message s
    end

    def error(s)
      log_message(s, :error)
    end

    def fatal(s)
      log_message(s, :fatal)
    end

    def info(s)
      log_message(s, :info)
    end

    private

    def log_message(s, label=:debug)

      charlimit = @maxcharlength
      fullmsg, topic = s.split(/ *: */,2).reverse

      msg = fullmsg.length <= charlimit ? fullmsg : \
             fullmsg[0..charlimit - 3] + '...'
      fqm = [@topic, label.to_s, topic || @subtopic]\
                .compact.join('/') + ': ' + msg
      @u.send fqm, 0, @address, @port
    end
  end

  def initialize(sps_host: nil, sps_port: 59000, 
                udp_host: '127.0.0.1', udp_port: '1024', subtopic: '')

    @udplog = UDPlog.new(udp_host, udp_port, topic='udplog', 
                        subtopic: subtopic)

    if sps_host then
      @spslog = SPSPubLogDRbClient.new(host: sps_host, port: sps_port) 
    end

  end

  def debug(s)
    @udplog.debug s
  end

  def error(s)
    @udplog.error s
    @spslog.error s if @spslog
  end

  def fatal(s)
    @spslog.fatal s if @spslog
  end

  def info(s)
    @udplog.info s
  end


end
