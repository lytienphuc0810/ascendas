# HOW TO RUN
	For ease of use, we can use docker:
	docker build -t my-ruby-app .
	docker run -p 2300:2300 my-ruby-app

# Sample request
	http://localhost:2300/hotels
	http://localhost:2300/hotels?hotels[]=SjyX
	http://localhost:2300/hotels?hotels[]=SjyX&hotels[]=f8c9
	http://localhost:2300/hotels?destination=5432
	or you can use a hosted ECS:
	http://ec2-54-169-44-192.ap-southeast-1.compute.amazonaws.com:2300/hotels?hotels[]=iJhz
	http://ec2-54-169-44-192.ap-southeast-1.compute.amazonaws.com:2300/hotels?destination=5432

# Decisions on data cleaning & selecting the best data

	1. Priorities data that matches the sample response
	2. Aggregate data of the same field amongs suppliers
	3. If different data exists in the same fields among suppliers, priorities in order of given suppliers list
	4. If duplication exists in the same fields among suppliers, proceed to remove duplicated data
	5. Strip left and right white space, lowcase all tag like data, remove falsy empty string lng/lat

# Solutions design

	1. Using Hanami for web server
	2. Using Entities for modeling the response & Domain Driven Design
	3. Have a Faraday Cache Middleware with file system cache of TTL 30 seconds
	4. Using a Service Object for skinny controller design

# Potential Improvement
	1. Use redis/memcache instead of file system cache for better performance & scalability
	2. Have a rule/mapper engine with ability for configuration instead of hard coding the mapping/aggeration data logic

# Test Coverage
	https://github.com/lytienphuc0810/ascendas/blob/main/coverage.png

# Test Pipeline & Sample Deployment
	1. Checkout my github action for linter & rspec at
	https://github.com/lytienphuc0810/ascendas/actions/workflows/verify.yml
	2. Checkout my github action for AWS ECS deployment at
	https://github.com/lytienphuc0810/ascendas/actions/workflows/deploy.yml
	Hosted instance can be accessed at http://ec2-54-169-44-192.ap-southeast-1.compute.amazonaws.com:2300

