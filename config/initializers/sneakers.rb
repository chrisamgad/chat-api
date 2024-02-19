Sneakers.configure :connection => Bunny.new(:host => ENV["RABBITMQ_HOST"], :vhost => "/", :user => ENV["RABBITMQ_USER"], :password => ENV["RABBITMQ_PASSWORD"]), :timeout_job_after => 360

# extra options that were used during debugging:

# :log => 'log/sneakers.log'
# :ack => true