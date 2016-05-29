require 'rubygems'
require 'bundler/setup'
require 'byebug'

require_relative 'game'

Console::Game.new.run
