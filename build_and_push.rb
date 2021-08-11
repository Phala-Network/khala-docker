#!/usr/bin/env ruby
# frozen_string_literal: true

BUILD_ONLY = false
GIT_TAG = "v0.0.10"

COMMON_CHAIN_NAME = "khala"
COMMON_TAG = GIT_TAG

NODE_DOCKER_REPO = "#{COMMON_CHAIN_NAME}-node"
NODE_DOCKER_TAG = COMMON_TAG
NODE_GIT_TAG = GIT_TAG

REGISTRIES = [
  "jasl123",
  "phalanetwork",
  "swr.cn-east-3.myhuaweicloud.com/phala",
  "docker.pkg.github.com/phala-network/khala-docker"
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
    "docker build --build-arg PHALA_GIT_TAG=#{NODE_GIT_TAG} -f node.Dockerfile -t #{registry}/#{NODE_DOCKER_REPO}:#{NODE_DOCKER_TAG} .",
    "docker build --build-arg PHALA_GIT_TAG=#{NODE_GIT_TAG} -f node.Dockerfile -t #{registry}/#{NODE_DOCKER_REPO} ."
  ].each do |cmd|
    puts cmd
    run cmd
  end
end

unless BUILD_ONLY
  # Push Khala-Node
  REGISTRIES.each do |registry|
    [
      "docker push #{registry}/#{NODE_DOCKER_REPO}:#{NODE_DOCKER_TAG}",
      "docker push #{registry}/#{NODE_DOCKER_REPO}"
    ].each do |cmd|
      puts cmd
      run cmd
    end
  end
end
