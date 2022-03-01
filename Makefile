TERRAFORM_VERSION=1.1.6
GIT_COMMIT_HASH=$(shell git rev-parse --short HEAD)

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
	--target=module.ecr-lambda-lock \
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


docker-push-lambda-example: ecr-login
	docker image rm lambda-images && \
	docker build -t lambda-images -f infra/docker/Dockerfile.lambda apps/lambdas/example/. && \
	docker tag lambda-images:latest ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:${GIT_COMMIT_HASH} && \
	docker tag lambda-images:latest ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:latest && \
	docker push ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:${GIT_COMMIT_HASH}
	docker push ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-images:latest

docker-push-lock: ecr-login
	docker image rm lambda-lock && \
	docker build -t lambda-lock -f infra/docker/Dockerfile.lambda apps/lambdas/lock/. && \
	docker tag lambda-lock:latest ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-lock:${GIT_COMMIT_HASH} && \
	docker tag lambda-lock:latest ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-lock:latest && \
	docker push ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-lock:${GIT_COMMIT_HASH}
	docker push ${AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/lambda-lock:latest

docker-push-all: docker-push-lambda-example docker-push-lock

reset_all: destroy apply-ecr docker-push-all apply
