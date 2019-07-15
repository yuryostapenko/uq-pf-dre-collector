$(aws ecr get-login --no-include-email --region ap-southeast-2)
docker-compose build
docker tag uq-its-ss-pf-dre:latest 665603700404.dkr.ecr.ap-southeast-2.amazonaws.com/uq-its-ss-pf-dre:latest
docker push 665603700404.dkr.ecr.ap-southeast-2.amazonaws.com/uq-its-ss-pf-dre:latest