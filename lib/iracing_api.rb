# frozen_string_literal: true
require 'uri'
require 'faraday'
require 'faraday-cookie_jar'
require 'json'
require_relative "iracing_api/version"

module IRacingAPI

  class Client

    BASE_URL = "https://members-ng.iracing.com/"

    def initialize(email, password)
      @email, @password = email, password
      authenticate!
      load_schema!
    end

    def method_missing(m, *args, &block)
      if @schema.keys.include?(m.to_s)
        
        if @schema[m.to_s].dig('get', 'parameters')
          available_params = @schema[m.to_s]['get']['parameters']
          required_params = available_params.select{|k,v| v.dig('required') == true }.keys.collect{|k| k.to_sym }
          supplied_args = args.collect{|p| p.keys.collect{|k| k.to_sym }}.flatten

          unless (required_params - supplied_args).empty?
            raise "The following params must be supplied: #{required_params}"
          end
        end
        
        get_request_with_cookies(@schema[m.to_s]['get']['link'], args.flatten[0])
      else 
        super
      end
    end

    private
    
    def load_schema!
      @schema = get_request_with_cookies('data/doc')
    end

    def authenticate!
      response = connection.post('auth') do |req|
        req.body = {'email' => @email, 'password' => @password}.to_json
      end
    end

    def get_request_with_cookies(uri, *params)
      response = connection.get(uri, params[0])
      body = JSON.parse(response.body)
      if body.has_key?("link")
        get_request body["link"]
      else
        body
      end
    end

    def get_request(uri)
      response = Faraday.get(uri)
      JSON.parse(response.body)
    end
    
    def connection
      @connection ||= Faraday.new(url: BASE_URL, headers: {'Content-Type' => 'application/json'}) do |builder|
        builder.use :cookie_jar
      end
    end
  end
end
