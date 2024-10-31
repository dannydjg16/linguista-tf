variable "healthcheckEndpoint" {
  description = "The endpoint to call for the app service health check"
  type        = string
  default     = "/healthz"  # Optional default value
}