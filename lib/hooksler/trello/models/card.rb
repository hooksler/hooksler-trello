module Hooksler
  module Trello
    module Models::Card
      def self.included(base)
        base.send :alias_method, :dispatch_before_card, :dispatch
        base.send(:define_method, :dispatch) do |_msg, action, data|
          return dispatch_before_card(_msg, action, data) unless data['type'] =~ /^[a-z]*Card/

          action_data = data['data']

          name = action_data['card']['name']
          board = action_data['board']['name']

          opts = {scope: 'trello.card', name: name, board: board, user: data['memberCreator']['fullName']}

          case action
            when 'copy'
              I18n.t 'copy', opts.merge(from: action_data['cardSource']['name'])
            when 'comment'
              I18n.t 'comment', opts
            when 'create'
              I18n.t 'create', opts
            when 'update'
              if action_data['old'].key?('idList')
                I18n.t 'move_to',
                       scope: 'trello.card.update',
                       name: name,
                       before: action_data['listBefore']['name'],
                       after: action_data['listAfter']['name']
              elsif action_data['old'].key?('closed')
                I18n.t action_data['card']['closed'] ? 'close' : 'open', opts
              end
          end
        end
      end
    end
  end
end
