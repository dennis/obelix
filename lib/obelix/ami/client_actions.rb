module Obelix
  module AMI
    class ClientActions
      def login(client, username, secret)
        AMIActions::Login.new(client, username, secret).execute
      end

      def database_del(client, family, key)
        AMIActions::DatabaseDel.new(client, family, key).execute
      end

      def database_put(client, family, key, value)
        AMIActions::DatabasePut.new(client, family, key, value).execute
      end

      def database_show(client)
        AMIActions::DatabaseShow.new(client).execute
      end
    end
  end
end
