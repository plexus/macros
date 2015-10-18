require_relative '../lib/macros'

$:.unshift File.dirname(__FILE__)

Macros.require 'my_macros'
Macros.require 'the_code'
