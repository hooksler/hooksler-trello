module Hooksler
  module Trello
    module Models::Checklist
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /Checklist/
        name = data['data']['checklist']['name']
        card = data['data']['card']['name']

        opts = {scope: 'trello.checklist', name: name, card: card}

        case action
          when 'remove'
            I18n.t 'remove', opts
          when 'update'
            I18n.t 'update', opts
          when 'add'
            I18n.t 'create', opts
        end
      end
    end
  end
end
