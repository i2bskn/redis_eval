DATABASES = { default: 10, second: 11, third: 12 }
Redis.current = Redis.new(db: DATABASES[:default])
