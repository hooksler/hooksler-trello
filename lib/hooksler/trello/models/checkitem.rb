module Hooksler
  module Trello
    module Models::Checkitem
      def dispatch(msg, action, data)
        return super unless data['type'] =~ /CheckItem/

        checklist =
            if (data['data'].key? 'checklist')
              data['data']['checklist']['name']
            else
              data['data']['cardSource']['name']
            end

        name =
            if data['data'].key? 'checkItem'
              data['data']['checkItem']['name']
            else
              data['data']['card']['name']
            end

        scope = 'trello.checkitem'


        case action
          when 'convert'
            I18n.t 'convert', scope: scope, name: name, checklist: checklist
          when 'delete'
            I18n.t 'remove', scope: scope, name: name, checklist: checklist
          when 'update'
            if data['data'].key? 'old'
              if data['data']['old'].key? 'name'
                I18n.t 'rename', scope: scope, new: name, checklist: checklist, name: data['data']['old']['name']
              end
            else
              case data['data']['checkItem']['state']
                when 'incomplete'
                  I18n.t 'unchecked', scope: scope, name: name, checklist: checklist
                when 'complete'
                  I18n.t 'checked', scope: scope, name: name, checklist: checklist
              end
            end
          when 'create'
            I18n.t 'create', scope: scope, name: name, checklist: checklist
        end
      end
    end
  end
end
