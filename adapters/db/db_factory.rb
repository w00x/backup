require_relative 'mysql_adapter'
require_relative 'postgres_adapter'

module Adapters
  module Db
    class DbFactory
      ADAPTERS = {
        'mysql' => 'Adapters::Db::MysqlAdapter',
        'postgres' => 'Adapters::Db::PostgresAdapter'
      }.freeze

      def self.build(adapter, host, user, dbname, dbuser, dbpassword, dbhost,
                     local_dbuser, local_dbname, local_dbpassword, filename,
                     private_key_path)
        Object.const_get(ADAPTERS[adapter]).new(host, user, dbname, dbuser,
                                                dbpassword, dbhost,
                                                local_dbuser, local_dbname,
                                                local_dbpassword, filename,
                                                private_key_path)
      end
    end

  end
end
