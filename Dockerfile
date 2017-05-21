FROM microsoft/aspnetcore:1.1.2

MAINTAINER alvarez.jeap@gmail.com

LABEL source="https://github.com/jealvarez/cars" \
      application-name="Cars" \
      port="5000"

WORKDIR /cars

EXPOSE 8000

ENV ASPNETCORE_URLS http://+:8000

COPY Docker/entrypoint.sh .
COPY bin/Release/netcoreapp1.1/publish .

RUN chmod +x entrypoint.sh
RUN useradd -m cars
RUN chown -R cars:cars /cars

USER cars

ENTRYPOINT ["/cars/entrypoint.sh"]

CMD ["dotnet", "/cars/Cars.dll", "--server.urls", "http://0.0.0.0:8000"]
