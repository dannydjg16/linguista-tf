variable "healthcheckEndpoint" {
  description = "The endpoint to call for the app service health check"
  type        = string
  default     = "/healthz"  # Optional default value
}

variable "dotnet8" {
  description = ".net8 version variable"
  type        = string
  default     = "8.0"  # Optional default value
}