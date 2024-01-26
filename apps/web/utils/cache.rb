# frozen_string_literal: true

class Cache
  FILECACHE = FileCache.new('filecache', '/tmp/caches', 60, 1)
  def read(key)
    print FILECACHE.get(key)
    FILECACHE.get(key)
  end

  def write(key, value)
    FILECACHE.set(key, value)
  end

  def delete(key)
    FILECACHE.set(key, nil)
  end
end
