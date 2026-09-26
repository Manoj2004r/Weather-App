variable "project_name"{
	type =  string
	default = "weather-app-front-end"
}
variable "weather_api_key" {
  description = "OpenWeatherMap API key"
  type        = string
  sensitive   = true
}
