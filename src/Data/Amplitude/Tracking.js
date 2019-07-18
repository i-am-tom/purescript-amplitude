'use strict'

var amplitude = typeof window == "undefined" ? {} : require('amplitude-js')
  , client    = null
  , error     = "Amplitude has not been initialised!"

exports.version = amplitude.__VERSION__

exports.clearUserPropertiesImpl = function (onError, onSuccess) {
  return client == null
    ? onError(error)
    : onSuccess(client.clearUserProperties())
}

exports.getSessionIdImpl = function (onError, onSuccess) {
  return client == null
    ? onError(error)
    : onSuccess(client.getSessionId())
}

exports.identifyImpl = function (builder) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : client.identify(
          builder(new client.Identify()), function (code, body) {
          200 <= code && code < 300
            ? onSuccess ({ code: code, body: body })
            : onError (body)
        })
  }
}

exports.initImpl = function (key, userId, config) {
  return function (onError, onSuccess) {
    client = amplitude.getInstance()

    // Forgive us, Padre. The problem here is that, regardless of whether the
    // initialisation succeeds or not, the result is always `undefined`. To
    // figure out whether or not anything actually _did_ work, we'll use a
    // little stateful flag.
    var didItWork = false
    client.init(key, userId, config, function () { didItWork = true })

    didItWork ? onSuccess() : onError()
  }
}

exports.isNewSessionImpl = function (onError, onSuccess) {
  return client == null
    ? onError(error)
    : onSuccess(client.isNewSession())
}

exports.logEventImpl = function (tag, payload) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : client.logEvent(tag, payload, function (code, body) {
          200 <= code && code < 300
            ? onSuccess ({ code: code, body: body })
            : onError   (body)
        })
  }
}

exports.logEventWithTimestampImpl = function (tag, payload, timestamp) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : client.logEvent(tag, payload, timestamp, function (code, body) {
          200 <= code && code < 300
            ? onSuccess ({ code: code, body: body })
            : onError   (body)
        })
  }
}

exports.logRevenueV2Impl = function (revenue) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.logRevenueV2(
          new client
                .Revenue()
                .setEventProperties(revenue.payload)
                .setPrice(revenue.price)
                .setProductId(revenue.productId)
                .setQuantity(revenue.quantity)
                .setRevenueType(revenue.revenueType)))
  }
}

exports.regenerateDeviceIdImpl = function (onError, onSuccess) {
  return client == null
    ? onError(error)
    : onSuccess(client.regenerateDeviceId())
}

exports.setDeviceIdImpl = function (deviceId) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setDeviceId(deviceId))
  }
}

exports.setDomainImpl = function (domain) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setDomain(domain))
  }
}

exports.setGroupImpl = function (groupType, groupName) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setGroup(groupType, groupName))
  }
}

exports.setOptOutImpl = function (enable) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setOptOut(enable))
  }
}

exports.setUserIdImpl = function (userId) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setUserId(userId))
  }
}

exports.setUserPropertiesImpl = function (userProperties) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setUserProperties(userProperties))
  }
}

exports.setVersionNameImpl = function (version) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setVersionName(version))
  }
}

exports.setSessionIdImpl = function (sessionId) {
  return function (onError, onSuccess) {
    return client == null
      ? onError(error)
      : onSuccess(client.setSessionId(sessionId))
  }
}
