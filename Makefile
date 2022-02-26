TERRAFORM_VERSION=1.1.6
include .env

load:
	echo ${AWS_REGION} ${AWS_REGION}
init:
	docker run --rm -it --name terraform \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	init

plan: init
	docker run --rm -it --name terraform \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	plan

apply: init
	docker run --rm -it --name terraform \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	apply \
	-auto-approve

apply-ecr: init
	docker run --rm -it --name terraform \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	apply \
	--target=module.ecr-lambdas \
	-auto-approve

destroy: init
	docker run --rm -it --name terraform \
	-v $(shell pwd)/infra/terraform/${ENV}:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	destroy \
	-auto-approve


ecr-login:
	AWS_REGION=${AWS_REGION} \
	AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com

docker-build:
	docker build -t lambda-images -f infra/docker/Dockerfile.lambda apps/lambdas
	 
docker-push: docker-build ecr-login
	docker tag lambda-images:latest ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:latest && \
	docker push ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:latest
