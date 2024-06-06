# config/initializers/prometheus_exporter.rb

if Rails.env.development? || Rails.env.production?
  require 'prometheus_exporter/middleware'
  require 'prometheus_exporter/instrumentation'

  Rails.application.middleware.unshift PrometheusExporter::Middleware

  PrometheusExporter::Instrumentation::Process.start(type: 'web')

  PrometheusExporter::Instrumentation::ActiveRecord.start(
    custom_labels: { service: 'notifier' }
  )

  PrometheusExporter::Instrumentation::Puma.start
end
