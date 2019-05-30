'use strict'

var amplitude = require('amplitude-js')

exports.version = amplitude.__VERSION__

exports.clearUserPropertiesImpl = function (client) {
  return client.clearUserProperties()
}

exports.getSessionIdImpl = function (client) {
  return client.getSessionId()
}

exports.identifyImpl = function (client, identify) {
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
    var client = amplitude.getInstance()

    amplitude.init(key, userId, config, function () {
      onSuccess(client)
    })
  }
}

exports.isNewSessionImpl = function (client) {
  return client.isNewSession()
}

exports.logEventImpl = function (client, tag, payload) {
  return function (onError, onSuccess) {
    client.logEvent(tag, payload, function (code, body) {
      200 <= code && code < 300
        ? onSuccess ({ code: code, body: body })
        : onError   (body)
    })
  }
}

exports.logEventWithTimestampImpl = function (client, tag, payload, timestamp) {
  return function (onError, onSuccess) {
    client.logEvent(tag, payload, timestamp, function (code, body) {
      200 <= code && code < 300
        ? onSuccess ({ code: code, body: body })
        : onError   (body)
    })
  }
}

exports.logRevenueV2Impl = function (client, revenue) {
  return client.logRevenueV2(
    new amplitude
          .Revenue()
          .setEventProperties(revenue.payload)
          .setPrice(revenue.price)
          .setProductId(revenue.productId)
          .setQuantity(revenue.quantity)
          .setRevenueType(revenue.revenueType))
}

exports.regenerateDeviceIdImpl = function (client) {
  return client.regenerateDeviceId()
}

exports.setDeviceIdImpl = function (client, deviceId) {
  return client.setDeviceId(deviceId)
}

exports.setDomainImpl = function (client, domain) {
  return client.setDomain(domain)
}

exports.setGroupImpl = function (client, groupType, groupName) {
  return client.setGroup(groupType, groupName)
}

exports.setOptOutImpl = function (client, enable) {
  return client.setOptOut(enable)
}

exports.setUserIdImpl = function (client, userId) {
  return client.setUserId(userId)
}

exports.setUserPropertiesImpl = function (client, userProperties) {
  return client.setUserProperties(userProperties)
}

exports.setVersionNameImpl = function (client, version) {
  return client.setVersionName(version)
}

exports.setSessionIdImpl = function (client, sessionId) {
  return client.setSessionId(sessionId)
}
