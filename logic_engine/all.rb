require 'thinginess'
require 'arcana'

require_relative 'level_controller'
require_relative 'level'
require_relative 'selected_word'

Dir[File.dirname(__FILE__) + '/things/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/tomes/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/levels/*.rb'].each { |file| require file }
