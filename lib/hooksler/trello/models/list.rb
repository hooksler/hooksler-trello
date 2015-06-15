module Hooksler
  module Trello
    module Models::List
      def self.included(base)
        base.send :alias_method, :dispatch_before_list, :dispatch
        base.send(:define_method, :dispatch) do |_msg, action, data|
          return dispatch_before_list(_msg, action,data) unless data['type'] =~ /List/
          name = data['data']['list']['name']
          board = data['data']['board']['name']
          user = data['memberCreator']['fullName']
          opts = {scope: 'trello.list', name: name, user: user, board: board}

          case action
            when 'update'
              I18n.t 'update', opts
            when 'create'
              I18n.t 'create', opts
          end
        end
      end
    end
  end
end