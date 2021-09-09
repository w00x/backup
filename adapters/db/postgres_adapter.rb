require_relative 'db_adapter'

module Adapters
  module Db
    class PostgresAdapter < DbAdapter
      def dump_command
        "PGPASSWORD='#{@dbpassword}' pg_dump -U #{@dbuser} -h #{@dbhost} "\
        "#{@dbname} | gzip > /tmp/#{@filename}"
      end

      def drop_local_command
        "PGPASSWORD='#{@local_dbpassword}' dropdb -U #{@local_dbuser} -h localhost "\
        "#{@local_dbname}"
      end

      def create_local_command
        "PGPASSWORD='#{@local_dbpassword}' createdb -U #{@local_dbuser} -h localhost "\
        "#{@local_dbname}"
      end

      def apply_command
        "gzip -d < /tmp/#{@filename} | "\
        "PGPASSWORD='#{@local_dbpassword}' psql -U #{@local_dbuser} #{@local_dbname} -h localhost"
      end
    end
  end
end
