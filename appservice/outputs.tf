output "default_site_hostname" {
  description = "The Hostname associated with the App Service"
  value       = format("https://%s/", azurerm_linux_web_app.webapp.default_site_hostname)
}
