require 'yaml'
require 'net/ssh'
require_relative 'adapters/db/db_factory'
require_relative 'utils'

con = YAML.load(File.read('./config.yml'))

begin
  validate!(con)
rescue Exception => ex
  puts ex.message
  return
end

config = con[ARGV[0]][ARGV[1]]
user = config['user']
host = config['host']
dbhost = config['dbhost']
adapter = config['adapter']
private_key_path = config['private_key_path']

filename = 'dump_'+config['dbname']+'_'+Time.now.strftime('%d%m%Y%H%M%S%L')+".sql.gz"

db_adapter = Adapters::Db::DbFactory.build(adapter, host, user,
                                           config['dbname'],
                                           config['dbuser'],
                                           config['dbpassword'],
                                           dbhost,
                                           config['local_dbuser'],
                                           config['local_dbname'],
                                           config['local_dbpassword'],
                                           filename, private_key_path)

db_adapter.generate_external_backup(ARGV[2])
download_external_backup(user, host, filename, private_key_path)
delete_external_backup(host, user, filename, private_key_path)

db_adapter.apply_backup if ARGV.size > 2 && (ARGV[2] == 'apply' || ARGV[3] == 'apply')
