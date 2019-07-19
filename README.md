Proof of concept for Data Collector
=========================================

1. [Set up](#set-up)
2. [Execution](#execution)

### Set up

####Local Docker

    sudo chmod +x docker-dev-image.sh
    ./docker-dev-image.sh
    
####Deploy to ECS
This should be managed by Jenkins, thus you don't need it. 

However, if you want to test, debug or update something, then:
 
Update config.sh
- Define BUILD_ID
- Define AWS_DEFAULT_REGION

Run
    
    sudo chmod +x docker-build-image.sh
    ./docker-build-image.sh

### Execution
    
####Local Docker
First time

    ./docker-dev-image.sh

Then
    
    docker-compose up
    
