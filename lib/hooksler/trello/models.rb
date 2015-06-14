module Hooksler
  module Trello
    module Models
      require 'hooksler/trello/models/card'
      require 'hooksler/trello/models/checkitem'
      require 'hooksler/trello/models/checklist'
      require 'hooksler/trello/models/list'

      def self.included(base)
        base.send( :define_method, :dispatch) { |*args| '' }

        [Card, Checkitem, Checklist, List].each do |m|
          base.send :include, m
        end

      end
    end
  end
end
