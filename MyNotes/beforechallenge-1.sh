# Explain to the team about containerizing a .NET core app and a node.js app in UBUNTU, or MACOS or WSL2 in windows dev environments and using VSCODE.

DEMO the following .NET core portion

# Containerizing a .NET core application

# to install .NET core 5.0 SDK and runtime in UBUNTU 20.04 and WSL2:
https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu

wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update; \ 
	sudo apt-get install -y apt-transport-https && \
	sudo apt-get update && \ sudo apt-get install -y dotnet-sdk-5.0

sudo apt-get update; \ 
	sudo apt-get install -y apt-transport-https && \ 
	sudo apt-get update && \ 
	sudo apt-get install -y aspnetcore-runtime-5.0

# MAIN REFERENCE
https://docs.microsoft.com/en-us/dotnet/core/docker/build-container?tabs=linux

# COMMANDS FOR THE DEMO:

# Create .NET Core app
dotnet new console -o App -n NetCore.Docker
cd App
tree
code .
dotnet run

# EDIT PROGRAM.CS
	using System;
	using System.Threading.Tasks;
	
	namespace NetCore.Docker
	{
	    class Program
	    {
	        static async Task Main(string[] args)
	        {
	            var counter = 0;
	            var max = args.Length != 0 ? Convert.ToInt32(args[0]) : -1;
	
	
	
	            while (max == -1 || counter < max)
	            {
	                Console.WriteLine($"Counter: {++counter}");
	                await Task.Delay(1000);
	            }
	        }
	    }
	}
	
# run the container
dotnet run
^C

dotnet run -- 5

# Publish .NET Core app
dotnet publish -c Release
tree

# CREATE DOCKERFILE
	FROM mcr.microsoft.com/dotnet/aspnet:3.1
	# COPY bin/Release/netcoreapp3.1/publish/ App/
	# WORKDIR /App
	# ENTRYPOINT ["dotnet", "NetCore.Docker.dll"]

docker build -t counter-image:1.0 -f Dockerfile .
docker images

# EDIT DOCKERFILE
	# FROM mcr.microsoft.com/dotnet/aspnet:3.1
	COPY bin/Release/netcoreapp3.1/publish/ App/
	WORKDIR /App
	ENTRYPOINT ["dotnet", "NetCore.Docker.dll"]
 

# Create a container
docker build -t counter-image:1.0 -f Dockerfile .
docker images
docker create --name core-counter counter-image
docker ps
docker ps -a

# Manage the container
docker start core-counter
docker ps
docker stop core-counter
docker ps

# Connect to a container
docker start core-counter
docker attach --sig-proxy=false core-counter
^C
docker stop core-counter
docker ps


# Single run
docker run -it --rm counter-image
docker ps
docker run -it --rm counter-image
docker run -it --rm counter-image 3


# Change the ENTRYPOINT
docker run -it --rm --entrypoint "bash" counter-image
docker ps
docker run -it --rm --entrypoint "bash" counter-image

# Clean up resources
docker ps -a
docker stop counter-image
docker rm counter-image
docker rmi counter-image:1.0
docker rmi mcr.microsoft.com/dotnet/aspnet:3.1


# ****** END OF DEMO ******





# (optional) Containerizing a NODE.JS application

# Install Node.js v15.x:
# In Ubuntu or WSL2:
curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt-get install -y nodejs
From <https://github.com/nodesource/distributions/blob/master/README.md#debinstall> 


# STEP  1:
https://docs.microsoft.com/en-us/windows/nodejs/web-frameworks

# STEP  2:
https://docs.microsoft.com/en-us/windows/nodejs/containers#create-a-container-image-with-dockerfile

# Which uses this Dockerfile for the node.js application:
	
	# Specifies where to get the base image (Node v12 in our case) and creates a new container for it
	FROM node:12
	
	# Set working directory. Paths will be relative this WORKDIR.
	WORKDIR /usr/src/app
	
	# Install dependencies
	COPY package*.json ./
	RUN npm install
	
	# Copy source files from host computer to the container
	COPY . .
	
	# Build the app
	RUN npm run build
	
	# Specify port app runs on
	EXPOSE 3000
	
	# Run the app
	CMD [ "npm", "start" ]
