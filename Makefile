# -------------------
# dotnet
# -------------------
dotnet-develop:
	dotnet restore && \
	dotnet build && \
	dotnet watch run

# -------------------
# docker
# -------------------
docker-build:
	git checkout tags/$(subst v, "", $(tag)) && \
	dotnet restore && \
	dotnet publish -c release && \
	docker build -t cars:$(tag) .

docker-run:
	docker run --rm -d --name cars -p 8000:8000 cars:$(tag)