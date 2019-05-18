FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app

COPY *.sln */*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p ./${file%.*}/ && mv $file ./${file%.*}/; done
RUN dotnet restore

COPY . ./

RUN dotnet publish -c Release -o /app/out


FROM microsoft/dotnet:2.1-aspnetcore-runtime AS final
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "testapp.dll"]