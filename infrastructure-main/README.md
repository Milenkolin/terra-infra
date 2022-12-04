# Infrastructure as code written in Terraform

A repository containing the Terraform configuration for various units of the StockPerks AWS environment. See below for repository structure and information on how to apply changes.

* `./basic`:

  Configuration that is not directly a part of any ECS cluster.

  Can be applied by commands:
  ```
  cd ./basic
  ./tf.sh init
  ./tf.sh apply
  ```

* `./develop-cluster`:

  Configuration for development ECS cluster and services.

  Can be applied by commands:
  ```
  cd ./develop-cluster/<ENV>/
  ./tf.sh init
  ./tf.sh apply -var="docker_image_tag=<DOCKER_TAG>"
  ```
  where `<ENV>` is ECS service name and `<DOCKER_TAG>` is a valid tag of Docker image for the service.

* `./prod-cluster`:

  Configuration for production ECS cluster and services.

  Can be applied by commands:
  ```
  cd ./prod-cluster/<ENV>/
  ./tf.sh init
  ./tf.sh apply -var="docker_image_tag=<DOCKER_TAG>"
  ```
  where `<ENV>` is ECS service name and `<DOCKER_TAG>` is a valid tag of Docker image for the service.
