module Data.Amplitude.Tracking.Config where

import Data.Time.Duration (Milliseconds)

type Config
  = ( -- If true, then events are batched together and uploaded only when the
      -- number of unsent events is greater than or equal to
      -- eventUploadThreshold or after `eventUploadPeriodMillis` milliseconds
      -- have passed since the first unsent event was logged.
      batchEvents ∷ Boolean

      -- The number of days after which the Amplitude cookie will expire.
    , cookieExpiration ∷ Int

      -- The custom name for the Amplitude cookie.
    , cookieName ∷ String

      -- The custom Device ID to set. _Note: This is not recommended unless
      -- you know what you are doing (e.g. you have your own system for
      -- tracking user devices)._
    , deviceId ∷ String

      -- If true, then the SDK will parse Device ID values from the URL
      -- parameter `amp_device_id` if available. Device IDs defined in the
      -- configuration options during init will take priority over Device IDs
      -- from URL parameters.
    , deviceIdFromUrlParam ∷ Boolean

      -- Set a custom domain for the Amplitude cookie.
      -- 
      -- To include subdomains, add a preceding period, eg:
      -- 
      -- ('.amplitude.com)
    , domain ∷ String

      -- Amount of time in milliseconds that the SDK waits before uploading
      -- events if `batchEvents` is `true`.
    , eventUploadPeriodMillis ∷ Milliseconds

      -- Minimum number of events to batch together per request if
      -- `batchEvents` is `true`.
    , eventUploadThreshold ∷ Int

      -- If true, the events will always be uploaded to HTTPS endpoint.
      -- Otherwise, it will use the embedding site's protocol.
    , forceHttps ∷ Boolean

      -- If true, captures the gclid URL parameter as well as the user's
      -- initial_gclid via a setOnce operation.
    , includeGclid ∷ Boolean

      -- If true, captures the referrer and referring_domain for each
      -- session, as well as the user's initial_referrer and
      -- initial_referring_domain via a setOnce operation.
    , includeReferrer ∷ Boolean

      -- If true, finds UTM parameters in the query string or the _utmz
      -- cookie, parses, and includes them as user properties on all events
      -- uploaded. This also captures initial UTM parameters for each session
      -- via a setOnce operation.
    , includeUtm ∷ Boolean

      -- Custom language to set.
    , language ∷ String

      -- Level of logs to be printed in the developer console. Valid values
      -- are 'DISABLE', 'ERROR', 'WARN', 'INFO'. To learn more about the
      -- different options, see the Advanced section.
    , logLevel ∷ String

      -- Whether or not to disable tracking for the current user.
    , optOut ∷ Boolean

      -- The custom platform to set.
    , platform ∷ String

      -- If `true`, saves events to localStorage and removes them upon
      -- successful upload. _Note: Without saving events, events may be lost
      -- if the user navigates to another page before the events are
      -- uploaded._
    , saveEvents ∷ Boolean

      -- Maximum number of events to save in localStorage. If more events are
      -- logged while offline, then old events are removed.
    , savedMaxCount ∷ Int

      -- If `true`, then `includeGclid`, `includeReferrer`, and `includeUtm`
      -- will only track their respective properties once per session. New
      -- values that come in during the middle of the user's session will be
      -- ignored. Set to `false` to always capture new values.
    , saveParamsReferrerOncePerSession ∷ Boolean

      -- The time between logged events before a new session starts in
      -- milliseconds.
    , sessionTimeout ∷ Milliseconds

      -- By default the JS SDK tracks various user properties such as city
      -- and country. You can disable the tracking of specific fields by
      -- passing in an object for `trackingOptions` that maps the field name
      -- to `false`.
    , trackingOptions ∷ TrackingOptions

      -- If `false`, the existing `referrer` and `utm_parameter` values will
      -- be carried through each new session. (Example: A user finds your
      -- website via Google and referrer is set to Google. The next day, the
      -- user accesses your website directly; referrer will remain as
      -- Google.)
      --
      -- If set to true, the `referrer` and `utm_parameter` user properties,
      -- which include referrer, `utm_source`, `utm_medium`, `utm_campaign`,
      -- `utm_term`, and `utm_content`, will be set to null upon
      -- instantiating a new session. (Example: A user finds your website via
      -- Google and referrer is set to Google. The next day, the user
      -- accesses your website directly; referrer will be set to null.)
      -- 
      -- Note: This only works if `includeReferrer` or `includeUtm`
      -- are set to true.
    , unsetParamsReferrerOnNewSession ∷ Boolean

      -- The maximum number of events to send to the server per request.
    , uploadBatchSize ∷ Int

    )

type TrackingOptions
  = { carrier      ∷ Boolean
    , city         ∷ Boolean
    , country      ∷ Boolean
    , device_model ∷ Boolean
    , dma          ∷ Boolean
    , ip_address   ∷ Boolean
    , language     ∷ Boolean
    , os_name      ∷ Boolean
    , os_version   ∷ Boolean
    , platform     ∷ Boolean
    , region       ∷ Boolean
    , version_name ∷ Boolean
    }
