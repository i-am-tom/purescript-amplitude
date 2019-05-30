'use strict'

var amplitude = require('amplitude-js')

exports.create = function (amplitude) {
  return new amplitude.Identify()
}

exports.addImpl = function (key, value, identify) {
  return identify.add(key, value)
}

exports.appendImpl = function (key, value, identify) {
  return identify.append(key, value)
}

exports.prependImpl = function (key, value, identify) {
  return identify.prepend(key, value)
}

exports.setImpl = function (key, value, identify) {
  return identify.set(key, value)
}

exports.setOnceImpl = function (key, value, identify) {
  return identify.setOnce(key, value)
}

exports.unsetImpl = function (key, identify) {
  return identify.unsetImpl(key)
}
