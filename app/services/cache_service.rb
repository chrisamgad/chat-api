class CacheService

    # writes to cache
    def self.write_to_cache(key, data = {})
        REDIS.hmset(key, data)
    end
    
    # reads from cache
    def self.read_from_cache(key)
        REDIS.hgetall(key)
    end
    
end
