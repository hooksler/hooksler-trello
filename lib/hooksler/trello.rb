require 'hooksler/trello/version'
require 'hooksler/trello/input'

module Hooksler
  module Trello
  end
end

I18n.load_path += Dir[ File.join( File.expand_path('../..', File.dirname(__FILE__) ) , 'config', 'locale', '*.yml' ) ]
I18n.backend.load_translations
