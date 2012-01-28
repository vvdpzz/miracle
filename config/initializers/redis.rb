require "redis"
require "redis-namespace"
require 'redis/objects'
require 'digest/sha1'

$redis = Redis.new(:host => "localhost", :port => 6379)

Redis::Objects.redis = $redis

Resque.redis = $redis

Resque.redis.namespace = "resque:segue"

class RedisHL
    def initialize(r)
        @redis = r
    end

    def get_hash_name(key)
        Digest::SHA1.hexdigest(key.to_s)[0..3]
    end

    def exists(key)
        @redis.hexists(get_hash_name(key))
    end

    def [](key)
        @redis.hget(get_hash_name(key),key)
    end

    def []=(key,value)
        @redis.hset(get_hash_name(key),key,value)
    end

    def incrby(key,incr)
        @redis.hincrby(get_hash_name(key),key,incr)
    end
end
