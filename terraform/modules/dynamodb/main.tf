# ---------------------------------------------------------------------------
# Amazon DynamoDB
# ---------------------------------------------------------------------------

# Still have to iterate properly for each attribute in table and so
resource "aws_dynamodb_table" "this" {
  for_each = var.tables

  name = each.key

  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity

  hash_key  = each.value.hash_key
  range_key = each.value.range_key

  dynamic "attribute" {
    for_each = each.value.attributes

    content {
      name = attribute.key
      type = attribute.value
    }
  }

  dynamic "local_secondary_index" {
    for_each = each.value.local_secondary_indexes

    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "global_secondary_index" {
    for_each = each.value.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "replica" {
    for_each = each.value.replica_regions

    content {
      region_name = replica.value.region_name
      kms_key_arn = lookup(replica.value, "kms_key_arn", null)
    }
  }

  server_side_encryption {
    enabled     = each.value.server_side_encryption_enabled
    kms_key_arn = each.value.server_side_encryption_kms_key_arn
  }

  tags = merge(
    each.value.tags,
    {
      "Name" = format("%s", each.key)
    },
  )
}
