# ---------------------------------------------------------------------------
# Amazon DynamoDB variables
# ---------------------------------------------------------------------------

variable "tables" {
  type = map(object({
    billing_mode                       = string
    read_capacity                      = string
    write_capacity                     = string
    hash_key                           = string
    range_key                          = string
    attributes                         = map(any)
    local_secondary_indexes            = map(any)
    global_secondary_indexes           = map(any)
    replica_regions                    = map(any)
    server_side_encryption_enabled     = bool
    server_side_encryption_kms_key_arn = string
    tags                               = map(string)
  }))
  description = "DynamoDB Tables"
}
