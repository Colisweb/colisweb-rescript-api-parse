@module("@colisweb/api/locale/fr.json")
external apiLocalesFr: array<Toolkit.Intl.translation> = "default"

@module("@colisweb/rescript-toolkit/locale/fr.json")
external toolkitLocalesFr: array<Toolkit.Intl.translation> = "default"

@module("@colisweb/api-components/locale/fr.json")
external apiComponentsLocalesFr: array<Toolkit.Intl.translation> = "default"

@module("@root/locale/fr.json")
external fr: array<Toolkit.Intl.translation> = "default"

include Toolkit.Intl.Make({
  let messages: Toolkit.Intl.messages = {
    fr: Array.concatMany([apiLocalesFr, toolkitLocalesFr, apiComponentsLocalesFr, fr]),
  }
  let defaultLocale = None
  let onError = message => Toolkit.BrowserLogger.error2("Intl error", message)
})
