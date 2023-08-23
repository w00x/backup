module Adapters
  module Db
    class DbAdapter
      def initialize(host, user, dbname, dbuser, dbpassword, dbhost, local_dbuser, local_dbname,
                     local_dbpassword, filename, private_key_path)
        @host = host
        @user = user
        @dbname = dbname
        @dbuser = dbuser
        @dbpassword = dbpassword
        @dbhost = dbhost
        @local_dbuser = local_dbuser
        @local_dbname = local_dbname
        @local_dbpassword = local_dbpassword
        @filename = filename
        @private_key_path = private_key_path
      end

      def generate_external_backup(schema)
        schema = nil if schema == 'apply'
        puts "Conectando con el servidor #{@host}"
        Net::SSH.start(@host, @user, keys: [@private_key_path]) do |ssh|
          puts 'Generando dump'
          ssh.exec(dump_command(schema))
        end
        puts "Archivo generado satisfactoriamente: /tmp/#{@filename}"
        puts 'Desconectando'
      end

      def apply_backup
        puts "Aplicando backup #{@filename} en #{@local_dbname}"
        system(drop_local_command)
        system(create_local_command)
        system(apply_command)
        puts 'Backup cargada satisfactoriamente'
      end

      def dump_command(_schema)
        raise NotImplementedError, self.class + \
                               "has not implemented method '#{__method__}'"
      end

      def drop_local_command
        raise NotImplementedError, self.class + \
                               "has not implemented method '#{__method__}'"
      end

      def create_local_command
        raise NotImplementedError, self.class + \
                               "has not implemented method '#{__method__}'"
      end

      def apply_command
        raise NotImplementedError, self.class + \
                               "has not implemented method '#{__method__}'"
      end
    end
  end
end
