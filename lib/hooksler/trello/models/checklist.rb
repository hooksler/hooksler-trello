module Hooksler
  module Trello
    module Models::Checklist
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /Checklist/
        name = data['data']['checklist']['name']
        card = data['data']['card']['name']

        scope = 'trello.checklist'

        case action
          when 'remove'
            I18n.t 'remove', scope: scope, name: name, card: card
          when 'update'
            I18n.t 'update', scope: scope, name: name, card: card
          when 'add'
            I18n.t 'create', scope: scope, name: name, card: card
        end
      end
    end
  end
end
