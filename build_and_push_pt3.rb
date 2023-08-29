#!/usr/bin/env ruby
# frozen_string_literal: true

BUILD_ONLY = false

COMMON_CHAIN_NAME = "khala-pt3"
COMMON_TAG = "23073101"

DEV_NODE_DOCKER_REPO = "#{COMMON_CHAIN_NAME}-node"
DEV_NODE_DOCKER_TAG = COMMON_TAG

REGISTRIES = [
  # "jasl123",
  "phalanetwork",
  # "swr.cn-east-3.myhuaweicloud.com/phala",
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

# Build Khala-Dev-Node
REGISTRIES.each do |registry|
  [
    "docker build -f prebuilt_pt3_node.Dockerfile -t #{registry}/#{DEV_NODE_DOCKER_REPO}:#{DEV_NODE_DOCKER_TAG} .",
    "docker build -f prebuilt_pt3_node.Dockerfile -t #{registry}/#{DEV_NODE_DOCKER_REPO} ."
  ].each do |cmd|
    puts cmd
    run cmd
  end
end

unless BUILD_ONLY
  # Push Khala-Dev-Node
  REGISTRIES.each do |registry|
    [
      "docker push #{registry}/#{DEV_NODE_DOCKER_REPO}:#{DEV_NODE_DOCKER_TAG}",
      "docker push #{registry}/#{DEV_NODE_DOCKER_REPO}"
    ].each do |cmd|
      puts cmd
      run cmd
    end
  end
end
