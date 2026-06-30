.PHONY: up deploy validate destroy plan fmt down

up:
	bash scripts/localstack-up.sh

deploy:
	bash scripts/deploy.sh

validate:
	bash scripts/validate.sh

plan:
	cd terraform && terraform init -input=false && terraform plan

fmt:
	cd terraform && terraform fmt -recursive && terraform validate

destroy:
	bash scripts/destroy.sh

down:
	docker compose down
