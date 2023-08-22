type mock
type worker

@module("msw") @variadic
external setupWorker: array<mock> => worker = "setupWorker"

type rec startOptions = {serviceWorker: serviceWorker}
and serviceWorker = {url: string}

@send
external start: (worker, startOptions) => unit = "start"
@send
external stop: worker => unit = "stop"

module Ctx = {
  type t

  @send
  external json: (t, 'a) => 'b = "json"
  @send
  external status: (t, 'a) => 'b = "status"
}

module Rest = {
  type req<'params> = {params: 'params}

  @module("msw") @scope("rest")
  external get: (string, (req<'params>, @uncurry ('z => 't), Ctx.t) => 'a) => mock = "get"
  @module("msw") @scope("rest")
  external put: (string, (req<'params>, @uncurry ('z => 't), Ctx.t) => 'a) => mock = "put"
  @module("msw") @scope("rest")
  external post: (string, (req<'params>, @uncurry ('z => 't), Ctx.t) => 'a) => mock = "post"
  @module("msw") @scope("rest")
  external delete: (string, (req<'params>, @uncurry ('z => 't), Ctx.t) => 'a) => mock = "delete"
}
