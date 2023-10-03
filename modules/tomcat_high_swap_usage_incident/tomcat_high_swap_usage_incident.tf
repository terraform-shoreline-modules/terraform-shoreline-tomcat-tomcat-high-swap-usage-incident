resource "shoreline_notebook" "tomcat_high_swap_usage_incident" {
  name       = "tomcat_high_swap_usage_incident"
  data       = file("${path.module}/data/tomcat_high_swap_usage_incident.json")
  depends_on = [shoreline_action.invoke_update_tomcat_config,shoreline_action.invoke_stop_start_tomcat]
}

resource "shoreline_file" "update_tomcat_config" {
  name             = "update_tomcat_config"
  input_file       = "${path.module}/data/update_tomcat_config.sh"
  md5              = filemd5("${path.module}/data/update_tomcat_config.sh")
  description      = "Review the Tomcat server configuration settings to ensure that the JVM heap size is optimized correctly."
  destination_path = "/agent/scripts/update_tomcat_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_tomcat" {
  name             = "stop_start_tomcat"
  input_file       = "${path.module}/data/stop_start_tomcat.sh"
  md5              = filemd5("${path.module}/data/stop_start_tomcat.sh")
  description      = "Restart the Tomcat server to clear the swap memory usage."
  destination_path = "/agent/scripts/stop_start_tomcat.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_tomcat_config" {
  name        = "invoke_update_tomcat_config"
  description = "Review the Tomcat server configuration settings to ensure that the JVM heap size is optimized correctly."
  command     = "`chmod +x /agent/scripts/update_tomcat_config.sh && /agent/scripts/update_tomcat_config.sh`"
  params      = ["PATH_TO_TOMCAT_CONFIG_FILE","DESIRED_HEAP_SIZE"]
  file_deps   = ["update_tomcat_config"]
  enabled     = true
  depends_on  = [shoreline_file.update_tomcat_config]
}

resource "shoreline_action" "invoke_stop_start_tomcat" {
  name        = "invoke_stop_start_tomcat"
  description = "Restart the Tomcat server to clear the swap memory usage."
  command     = "`chmod +x /agent/scripts/stop_start_tomcat.sh && /agent/scripts/stop_start_tomcat.sh`"
  params      = []
  file_deps   = ["stop_start_tomcat"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_tomcat]
}

