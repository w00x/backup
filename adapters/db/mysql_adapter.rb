require_relative 'db_adapter'

module Adapters
  module Db
    class MysqlAdapter < DbAdapter
      def dump_command
        "mysqldump -h#{@dbhost}  -u#{@dbuser} -p#{@dbpassword} --quick "\
        "--single-transaction #{@dbname} | gzip > /tmp/#{@filename}"
      end

      def drop_local_command
        "mysqladmin -u#{@local_dbuser} -p#{@local_dbpassword} -f "\
        "drop #{@local_dbname} --protocol=TCP"
      end

      def create_local_command
        "mysqladmin -u#{@local_dbuser} -p#{@local_dbpassword} "\
        "create #{@local_dbname} --protocol=TCP"
      end

      def apply_command
        "gzip -d < /tmp/#{@filename} | mysql -u#{@local_dbuser} "\
        "-p#{@local_dbpassword} #{@local_dbname} --protocol=TCP"
      end
    end
  end
end
