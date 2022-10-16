#!/usr/bin/env ruby
# frozen_string_literal: true

BUILD_ONLY = false
GIT_TAG = "v0.1.18-2"

COMMON_CHAIN_NAME = "khala"
COMMON_TAG = GIT_TAG

NODE_BIN_DOCKER_REPO = "#{COMMON_CHAIN_NAME}-node-bin"
NODE_BIN_DOCKER_TAG = COMMON_TAG
NODE_BIN_GIT_TAG = GIT_TAG

NODE_WITH_LAUNCHER_DOCKER_REPO = "#{COMMON_CHAIN_NAME}-node"
NODE_WITH_LAUNCHER_DOCKER_TAG = NODE_BIN_DOCKER_TAG

REGISTRIES = [
  "jasl123",
  "phalanetwork",
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
    "docker build --build-arg PHALA_GIT_TAG=#{NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{NODE_BIN_DOCKER_REPO}:#{NODE_BIN_DOCKER_TAG} .",
    "docker build --build-arg PHALA_GIT_TAG=#{NODE_BIN_GIT_TAG} -f node-bin.Dockerfile -t #{registry}/#{NODE_BIN_DOCKER_REPO} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{NODE_BIN_DOCKER_REPO}:#{NODE_BIN_DOCKER_TAG} -f node-with-launcher.Dockerfile -t #{registry}/#{NODE_WITH_LAUNCHER_DOCKER_REPO}:#{NODE_BIN_DOCKER_TAG} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{NODE_BIN_DOCKER_REPO}:#{NODE_BIN_DOCKER_TAG} -f node-with-launcher.Dockerfile -t #{registry}/#{NODE_WITH_LAUNCHER_DOCKER_REPO} ."
  ].each do |cmd|
    puts cmd
    run cmd
  end
end

unless BUILD_ONLY
  # Push Khala-Node
  REGISTRIES.each do |registry|
    [
      "docker push #{registry}/#{NODE_BIN_DOCKER_REPO}:#{NODE_BIN_DOCKER_TAG}",
      "docker push #{registry}/#{NODE_BIN_DOCKER_REPO}",
      "docker push #{registry}/#{NODE_WITH_LAUNCHER_DOCKER_REPO}:#{NODE_WITH_LAUNCHER_DOCKER_TAG}",
      "docker push #{registry}/#{NODE_WITH_LAUNCHER_DOCKER_REPO}"
    ].each do |cmd|
      puts cmd
      run cmd
    end
  end
end

# Build Phala-Node
REGISTRIES.each do |registry|
  [
    "docker build --build-arg PHALA_GIT_TAG=#{"rescue"} -f phala-node-bin.Dockerfile -t #{registry}/#{"phala-node-bin"}:#{"v0.1.13"} .",
    "docker build --build-arg PHALA_GIT_TAG=#{"rescue"} -f phala-node-bin.Dockerfile -t #{registry}/#{"phala-node-bin"} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{"phala-node-bin"}:#{"v0.1.13"} -f phala-node-with-launcher.Dockerfile -t #{registry}/#{"phala-node"}:#{"v0.1.13"} .",
    "docker build --build-arg NODE_BIN_IMAGE=#{registry}/#{"phala-node-bin"}:#{"v0.1.13"} -f phala-node-with-launcher.Dockerfile -t #{registry}/#{"phala-node-bin"} ."
  ].each do |cmd|
    puts cmd
    run cmd
  end
end

unless BUILD_ONLY
  # Push Phala-Node
  REGISTRIES.each do |registry|
    [
      "docker push #{registry}/#{"phala-node-bin"}:#{"v0.1.13"}",
      "docker push #{registry}/#{"phala-node-bin"}",
      "docker push #{registry}/#{"phala-node"}:#{"v0.1.13"}",
      "docker push #{registry}/#{"phala-node"}"
    ].each do |cmd|
      puts cmd
      run cmd
    end
  end
end
