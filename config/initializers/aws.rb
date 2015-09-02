AWS.config(access_key_id:     ENV['AKIAIBB4MQIDRQOEINFQ'],
           secret_access_key: ENV['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'] )

S3_BUCKET = AWS::S3.new.buckets[ENV['phoebes-pins']]
