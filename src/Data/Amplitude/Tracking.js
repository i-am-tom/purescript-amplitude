'use strict'

var amplitude = require('amplitude-js')
  , client    = null
  , error     = new Error("Amplitude has not been initialised!")

exports.version = amplitude.__VERSION__

exports.clearUserProperties = function () {
  if (client == null) throw error
  client.clearUserProperties()
}

exports.getSessionIdImpl = function () {
  if (client == null) throw error
  return client.getSessionId()
}

exports.identifyImpl = function (identify) {
  if (client == null) throw error

  return function (onError, onSuccess) {
    client.identify(identify, function (code, body) {
      200 <= code && code < 300
        ? onSuccess ({ code: code, body: body })
        : onError   (body)
    })
  }
}

exports.initImpl = function (key, userId, config) {
  return function (onError, onSuccess) {
    client = amplitude.getInstance()

    client.init(key, userId, config, function () {
      onSuccess()
    })
  }
}

exports.isNewSession = function () {
  if (client == null) throw error
  return client.isNewSession()
}

exports.logEventImpl = function (tag, payload) {
  if (client == null) throw error

  return function (onError, onSuccess) {
    client.logEvent(tag, payload, function (code, body) {
      200 <= code && code < 300
        ? onSuccess ({ code: code, body: body })
        : onError   (body)
    })
  }
}

exports.logEventWithTimestampImpl = function (tag, payload, timestamp) {
  if (client == null) throw error

  return function (onError, onSuccess) {
    client.logEvent(tag, payload, timestamp, function (code, body) {
      200 <= code && code < 300
        ? onSuccess ({ code: code, body: body })
        : onError   (body)
    })
  }
}

exports.logRevenueV2Impl = function (revenue) {
  if (client == null) throw error

  return client.logRevenueV2(
    new client
          .Revenue()
          .setEventProperties(revenue.payload)
          .setPrice(revenue.price)
          .setProductId(revenue.productId)
          .setQuantity(revenue.quantity)
          .setRevenueType(revenue.revenueType))
}

exports.regenerateDeviceId = function () {
  if (client == null) throw error
  return client.regenerateDeviceId()
}

exports.setDeviceIdImpl = function (deviceId) {
  if (client == null) throw error
  return client.setDeviceId(deviceId)
}

exports.setDomainImpl = function (domain) {
  if (client == null) throw error
  return client.setDomain(domain)
}

exports.setGroupImpl = function (groupType, groupName) {
  if (client == null) throw error
  return client.setGroup(groupType, groupName)
}

exports.setOptOutImpl = function (enable) {
  if (client == null) throw error
  return client.setOptOut(enable)
}

exports.setUserIdImpl = function (userId) {
  if (client == null) throw error
  return client.setUserId(userId)
}

exports.setUserPropertiesImpl = function (userProperties) {
  if (client == null) throw error
  return client.setUserProperties(userProperties)
}

exports.setVersionNameImpl = function (version) {
  if (client == null) throw error
  return client.setVersionName(version)
}

exports.setSessionIdImpl = function (sessionId) {
  if (client == null) throw error
  return client.setSessionId(sessionId)
}
