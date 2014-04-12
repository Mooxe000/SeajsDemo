#!/usr/bin/env coffee
require 'shelljs/make'

pkgs = [
  "seajs/seajs-text"
  "seajs/seajs-style"
  "seajs/seajs-log"
  "seajs/seajs-health"
  "seajs/seajs-flush"
  "seajs/seajs-debug"
  "seajs/seajs-combo"
  "seajs/seajs"
  "mooxe/modernizr"
  "mooxe/pure"
  "mooxe/semantic-ui"
  "mooxe/font-awesome"
  "mooxe/jquery"
  "mooxe/coffee-script"
  "mooxe/less"
  "mooxe/jade"
  "mooxe/markdown"
  "mooxe/normalize-css"
  "mooxe/respond"
  "jquery/jquery"
  "jquery/easing"
]

target.build = ->
  for pkg in pkgs
    exec "spm install #{pkg}"

target.clean = ->
  rm "-rf", "sea-modules"

target.all = ->
  target.clean()