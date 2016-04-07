require "redis"
require "redis-namespace"

def backup_redis origin_env, destination_env
  redis_conn = Redis.new(:host => "localhost", :port => 6381)
  $redis_prod = Redis::Namespace.new(origin_env, :redis => redis_conn)
  $redis_local = Redis::Namespace.new(destination_env, :redis => redis_conn)

  prod_keys = []
  scan_index = 0
  while true
    result = $redis_prod.scan(scan_index)
    prod_keys += result[1].select{|s| !s.include?('stat') && !s.include?('queues') &&
                        !s.include?('processes') && !s.include?('ip-')}
    scan_index = result[0].to_i
    break if scan_index == 0
  end
  local_keys = []
  scan_index = 0
  while true
    result = $redis_local.scan(scan_index)
    local_keys += result[1].select{|s| !s.include?('stat') && !s.include?('queues') &&
                        !s.include?('processes') && !s.include?('ip-')}
    scan_index = result[0].to_i
    break if scan_index == 0
  end
  local_keys.flatten.each do |key|
    $redis_local.del(key)
  end
  prod_keys.flatten.each do |key|
    val = $redis_prod.get(key)
    $redis_local.set(key, val)
  end
end
