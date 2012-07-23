#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'awesome_print'
require_relative '../lib/convert_pdf2csv.rb'

def error(message)
        puts "ERROR: %s" % [message]
        puts
        exit()
end

unless ARGV.length == 1
        error "give me path to PDF file"
end

input  = ARGV[0]

unless input =~ /\.pdf/i
        error "%s it's bad name for PDF file" % [input]
end

output = input.gsub(/\.pdf$/i, ".csv")


unless File.exists? input
        error "can't find file %s" % [input]
end

converter = Convert_pdf2csv.new

converter.parsePDF(input, 'CP1251')
converter.generateCSV(output)

puts "save result to %s" % [output]
puts