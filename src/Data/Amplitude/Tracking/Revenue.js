'use strict'

var amplitude = require('amplitude-js')

exports.create = function () {
  return new amplitude.Revenue()
}

exports.setEventPropertiesImpl = function (payload, revenue) {
  return revenue.setEventProperties(payload)
}

exports.setPriceImpl = function (price, revenue) {
  return revenue.setPrice(price)
}

exports.setProductIdImpl = function (productId, revenue) {
  return revenue.setProductId(productId)
}

exports.setQuantityImpl = function (quantity, revenue) {
  return revenue.setQuantity(quantity)
}

exports.setRevenueTypeImpl = function (quantity, revenue) {
  return revenue.setRevenueType(quantity)
}
