workflow "Release Docker Image" {
  on = "push"
  resolves = ["Docker Image Push"]
}

action "Docker Image Build" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "image build --build-arg VERSION=1.10 -t rawkode/telegraf:sys ."
  runs = "docker"
}

action "Docker Registry Login" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Image Build"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Docker Image Push" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Image Build", "Docker Registry Login"]
  args = "image push rawkode/telegraf:sys"
  runs = "docker"
}
