module Hooksler
  module Trello
    module Models::Checkitem
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /CheckItem/

        action_data = data['data']

        checklist = (action_data['checklist'] || action_data['cardSource'])['name']
        name =      (action_data['checkItem'] || action_data['card'])['name']

        opts = {scope: 'trello.checkitem', name: name, checklist: checklist}

        case action
          when 'convert'
            I18n.t 'convert', opts
          when 'delete'
            I18n.t 'remove', opts
          when 'update'
            if action_data.key? 'old'
              if action_data['old'].key? 'name'
                I18n.t 'rename', opts.merge(new: name, name: action_data['old']['name'])
              end
            else
              case action_data['checkItem']['state']
                when 'incomplete'
                  I18n.t 'unchecked', opts
                when 'complete'
                  I18n.t 'checked', opts
              end
            end
          when 'create'
            I18n.t 'create', opts
        end
      end
    end
  end
end
