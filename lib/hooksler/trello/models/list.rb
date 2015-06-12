module Hooksler
  module Trello
    module Models::List
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /List/
        name = data['data']['list']['name']
        board = data['data']['board']['name']
        user = data['memberCreator']['fullName']

        case action
          when 'update'
            I18n.t 'update', scope: 'trello.list', name: name, user: user, board: board
          when 'create'
            I18n.t 'create', scope: 'trello.list', name: name, user: user, board: board
        end
      end
    end
  end
end
