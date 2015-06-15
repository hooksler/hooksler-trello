module Hooksler
  module Trello
    module Models::Checklist
      def self.included(base)
        base.send :alias_method, :dispatch_before_checklist, :dispatch
        base.send(:define_method, :dispatch) do |_msg, action, data|

          return dispatch_before_checklist(_msg, action,data) unless data['type'] =~ /Checklist/
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
end