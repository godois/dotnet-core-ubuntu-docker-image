#!/usr/bin/env bash

dotnet new console -o hwapp
sleep 2
dotnet restore /opt/dotnet/hwapp/
sleep 2
dotnet run --project hwapp/hwapp.csproj
