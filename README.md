# HOW TO RUN

	docker build -t my-ruby-app .

	docker run --mount type=bind,source=<your-absolute-path-to-this-repo>,target=/usr/src/app -it --entrypoint /bin/bash -p 2300:2300 my-ruby-app

	bundle

	bundle exec hanami server --host=0.0.0.0

# Sample request
	http://localhost:2300/hotels
	http://localhost:2300/hotels?hotels[]=SjyX
	http://localhost:2300/hotels?hotels[]=SjyX&hotels[]=f8c9
	http://localhost:2300/hotels?destination=5432

# Decisions on data cleaning & selecting the best data

	1. Priorities data that matches the sample response
	2. If different data exists in the same fields among suppliers, priorities in order of given suppliers list
	3. If duplication exists in the same fields among suppliers, proceed to remove duplicated data
	4. Strip left and right white space, lowcase all tag like data, remove falsy empty string lng/lat

# Solutions design

	1. Using hanami as I think you guys at Ascenda are working with it
	2. Using Entities for modeling the response
	3. Can use faraday cache for caching request to data suppliers

# Test specifications

	1. I dont have time for this, please give the consideration of a small take home task within 5 ~ 6 hours
