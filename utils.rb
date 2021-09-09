def download_external_backup(user,host,filename, private_key_path)
  puts "Copiando archivo del host remoto"
  system("scp -i #{private_key_path} #{user}@#{host}:/tmp/#{filename} /tmp/#{filename}")
  puts "Archivo copiado satisfactoriamente: /tmp/#{filename}"
end

def delete_external_backup(host,user,filename, private_key_path)
  puts "Conectando con el servidor #{host} para eliminar backup remoto"
  Net::SSH.start(host, user, keys: [private_key_path]) do |ssh|
    puts "Eliminando backup remoto"
    ssh.exec("rm /tmp/#{filename}")
    puts "Backup eliminado satisfactoriamente: /tmp/#{filename}"
    puts "Desconectando"
  end
end

def validate!(con)
  unless (File.exist?('./config.yml'))
    raise Exception.new 'Falta archivo de configuracion, verifica que el archivo config.yml '\
                        'exista, de lo contrario renombra el archivo _config.yml'
  end

  unless (ARGV.size >= 2)
    raise Exception.new "Faltan parametros\n"\
                        './backup [instance] [environment] (apply)'
  end

  unless con.key?(ARGV[0]) && con[ARGV[0]].key?(ARGV[1])
    raise Exception.new 'No se encontraron los parametros en la configuración'
  end
end