exception RequestError
exception DecodeError(Decco.decodeError)

type request<'response, 'error> =
  | Idle
  | Loading
  | Done('response)
  | Error('error)

let wait = ms =>
  Js.Promise.make((~resolve, ~reject as _) => {
    Js.Global.setTimeout(() => {
      let data = ()
      resolve(. data)
    }, ms)->ignore
  })
