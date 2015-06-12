module Hooksler
  module Trello
    module Models::Card
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /^[a-z]*Card/

        name = data['data']['card']['name']
        board = data['data']['board']['name']
        scope = 'trello.card'

        case action
          when 'copy'
            I18n.t 'copy',
                   scope: scope,
                   name: name,
                   board: board,
                   from: data['data']['cardSource']['name']
          when 'comment'
            I18n.t 'comment',
                   scope: scope,
                   name: name,
                   user: data['memberCreator']['fullName']
          when 'create'
            I18n.t 'create',
                   scope: scope,
                   name: name,
                   board: board
          when 'update'
            if data['data']['old'].key?('idList')
              I18n.t 'move_to',
                     scope: "#{scope}.update",
                     name: name,
                     before: data['data']['listBefore']['name'],
                     after: data['data']['listAfter']['name']
            elsif data['data']['old'].key?('closed')
              I18n.t data['data']['card']['closed'] ? 'close' : 'open',
                     scope: scope,
                     name: name,
                     board: board
            end
        end
      end
    end
  end
end
