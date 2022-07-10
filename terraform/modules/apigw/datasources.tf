# ---------------------------------------------------------------------------
# Amazon API Gateway datasources
# ---------------------------------------------------------------------------

data "template_file" "this" {
  template = var.api_template

  vars = var.api_template_vars
}
