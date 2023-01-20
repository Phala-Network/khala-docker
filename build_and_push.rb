#!/usr/bin/env ruby
# frozen_string_literal: true

BUILD_ONLY = false
GIT_TAG = "v0.1.21-dev.1"

COMMON_TAG = GIT_TAG

KHALA_NODE_BIN_DOCKER_REPO = "khala-node-bin"
KHALA_NODE_BIN_DOCKER_TAG = COMMON_TAG
KHALA_NODE_BIN_GIT_TAG = GIT_TAG

PHALA_NODE_BIN_DOCKER_REPO = "phala-node-bin"
PHALA_NODE_BIN_DOCKER_TAG = COMMON_TAG
PHALA_NODE_BIN_GIT_TAG = GIT_TAG

KHALA_NODE_WITH_LAUNCHER_DOCKER_REPO = "khala-node"
KHALA_NODE_WITH_LAUNCHER_DOCKER_TAG = PHALA_NODE_BIN_DOCKER_TAG

PHALA_NODE_WITH_LAUNCHER_DOCKER_REPO = "phala-node"
PHALA_NODE_WITH_LAUNCHER_DOCKER_TAG = PHALA_NODE_BIN_DOCKER_TAG

REGISTRIES = [
  "jasl123",
  # "phalanetwork",
  # "swr.cn-east-3.myhuaweicloud.com/phala",
  # "docker.pkg.github.com/phala-network/khala-docker"
]

require "open3"

def run(cmd)
  Open3.popen2e(cmd) do |_stdin, stdout_err, wait_thr|
    while (line = stdout_err.gets)
      puts line
    end
  
    exit_status = wait_thr.value
    unless exit_status.success?
      abort "error"
    end
  end
end

# Build Khala-Node
REGISTRIES.each do |registry|
  [
    "docker build --build-arg PHALA_GIT_TAG=#{KHALA_NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{KHALA_NODE_BIN_DOCKER_REPO}:#{KHALA_NODE_BIN_DOCKER_TAG} .",
    "docker build --build-arg PHALA_GIT_TAG=#{KHALA_NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{KHALA_NODE_BIN_DOCKER_REPO} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{KHALA_NODE_BIN_DOCKER_REPO}:#{KHALA_NODE_BIN_DOCKER_TAG} -f khala-node-with-launcher.Dockerfile -t #{registry}/#{KHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}:#{KHALA_NODE_BIN_DOCKER_TAG} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{KHALA_NODE_BIN_DOCKER_REPO}:#{KHALA_NODE_BIN_DOCKER_TAG} -f khala-node-with-launcher.Dockerfile -t #{registry}/#{KHALA_NODE_WITH_LAUNCHER_DOCKER_REPO} ."
  ].each do |cmd|
    puts cmd
    run cmd
  end
end

unless BUILD_ONLY
  # Push Khala-Node
  REGISTRIES.each do |registry|
    [
      "docker push #{registry}/#{KHALA_NODE_BIN_DOCKER_REPO}:#{KHALA_NODE_BIN_DOCKER_TAG}",
      "docker push #{registry}/#{KHALA_NODE_BIN_DOCKER_REPO}",
      "docker push #{registry}/#{KHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}:#{KHALA_NODE_WITH_LAUNCHER_DOCKER_TAG}",
      "docker push #{registry}/#{KHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}"
    ].each do |cmd|
      puts cmd
      run cmd
    end
  end
end

# # Build Phala-Node
# REGISTRIES.each do |registry|
#   [
#     "docker build --build-arg PHALA_GIT_TAG=#{PHALA_NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{PHALA_NODE_BIN_DOCKER_REPO}:#{PHALA_NODE_BIN_DOCKER_TAG} .",
#     "docker build --build-arg PHALA_GIT_TAG=#{PHALA_NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{PHALA_NODE_BIN_DOCKER_REPO} .",
#     "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{PHALA_NODE_BIN_DOCKER_REPO}:#{PHALA_NODE_BIN_DOCKER_TAG} -f phala-node-with-launcher.Dockerfile -t #{registry}/#{PHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}:#{PHALA_NODE_BIN_DOCKER_TAG} .",
#     "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{PHALA_NODE_BIN_DOCKER_REPO}:#{PHALA_NODE_BIN_DOCKER_TAG} -f phala-node-with-launcher.Dockerfile -t #{registry}/#{PHALA_NODE_WITH_LAUNCHER_DOCKER_REPO} ."
#   ].each do |cmd|
#     puts cmd
#     run cmd
#   end
# end

# unless BUILD_ONLY
#   # Push Phala-Node
#   REGISTRIES.each do |registry|
#     [
#       "docker push #{registry}/#{PHALA_NODE_BIN_DOCKER_REPO}:#{PHALA_NODE_BIN_DOCKER_TAG}",
#       "docker push #{registry}/#{PHALA_NODE_BIN_DOCKER_REPO}",
#       "docker push #{registry}/#{PHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}:#{PHALA_NODE_WITH_LAUNCHER_DOCKER_TAG}",
#       "docker push #{registry}/#{PHALA_NODE_WITH_LAUNCHER_DOCKER_REPO}"
#     ].each do |cmd|
#       puts cmd
#       run cmd
#     end
#   end
# end
