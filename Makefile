TERRAFORM_VERSION=1.1.6

init:
	docker run --rm -it --name terraform \
	-v $(shell pwd):/workspace \
	-w /workspace \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	init

plan:
	docker run --rm -it --name terraform \
	-v $(shell pwd):/workspace \
	-w /workspace \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	plan

apply:
	docker run --rm -it --name terraform \
	-v $(shell pwd):/workspace \
	-w /workspace \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	apply

destroy:
	docker run --rm -it --name terraform \
	-v $(shell pwd):/workspace \
	-w /workspace \
	hashicorp/terraform:${TERRAFORM_VERSION} \
	destroy