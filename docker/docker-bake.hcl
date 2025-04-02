group "default" {
  targets = [
    "base",
  ]
}

// For docker/metadata-action
target "docker-metadata-action-base" {}

target "base" {
  inherits = ["docker-metadata-action-base"]
  dockerfile = "docker/Dockerfile"
  target = "base"
}