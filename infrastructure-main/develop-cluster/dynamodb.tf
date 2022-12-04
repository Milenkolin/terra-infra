resource "aws_dynamodb_table" "develop_brokers_users_plaid" {
  name           = "develop.brokers.users.plaid"
  read_capacity  = 0
  write_capacity = 0
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "plaidUserId"
    type = "S"
  }

  global_secondary_index {
    name               = "plaidUserIdIndex"
    hash_key           = "plaidUserId"
    write_capacity     = 0
    read_capacity      = 0
    projection_type    = "ALL"
    non_key_attributes = []
  }
}

resource "aws_dynamodb_table" "develop_brokers_users_hashes_plaid" {
  name           = "develop.brokers.users.hashes.plaid"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key = "hash"

  attribute {
    name = "hash"
    type = "S"
  }
}

resource "aws_dynamodb_table" "develop_configurations" {
  name           = "develop.configurations"
  read_capacity  = 1
  write_capacity = 1
  billing_mode   = "PROVISIONED"
  hash_key = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "develop_portfolios" {
  name           = "develop.portfolios"
  read_capacity  = 0
  write_capacity = 0
  billing_mode   = "PAY_PER_REQUEST"
  hash_key = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "date"
    type = "N"
  }

  ttl {
    attribute_name = "date"
    enabled        = false
  }

  global_secondary_index {
    name               = "dateIndex"
    hash_key           = "pk"
    range_key          = "date"
    write_capacity     = 0
    read_capacity      = 0
    projection_type    = "ALL"
    non_key_attributes = []
  }
}


resource "aws_dynamodb_table" "develop_user_eligibility" {
  name           = "develop.user_eligibility"
  read_capacity  = 0
  write_capacity = 0
  billing_mode   = "PAY_PER_REQUEST"
  hash_key = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

  ttl {
    attribute_name = "date"
    enabled        = false
  }
}