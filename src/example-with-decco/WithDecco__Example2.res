open! Utils

// The encoder is not needed
@decco.decode
type rec deliveriesResponse = array<delivery>
@decco
and delivery = {
  id: string,
  address: string,
  country: option<string>,
  clientName: option<string>,
  timeslot: timeslot,
}
@decco
and timeslot = {
  start: string,
  end: string,
}

let fetchDeliveries = async () => {
  await wait(2000)

  try {
    let response = await Axios.get("http://someapi.com/deliveriesFail")
    let deliveriesDecoding = response["data"]->deliveriesResponse_decode

    switch deliveriesDecoding {
    | Ok(deliveries) => Done(deliveries)
    | Error(decodingError) => {
        Js.log(decodingError)
        Error(DecodeError(decodingError))
      }
    }
  } catch {
  | Js.Exn.Error(e) => {
      Js.log(e)
      Error(RequestError)
    }
  }
}

@module("@root/src/example-with-decco/WithDecco__Example2.res?raw")
external codeExample: string = "default"

@react.component
let make = () => {
  let (request, setRequest) = React.useState((): request<deliveriesResponse, 'a> => Idle)
  let {setState} = React.useContext(CodeBlock.Context.context)

  <div>
    <h3 className="text-lg text-slate-500 flex flex-row items-center gap-2">
      {"Example 2 (decoding failure)"->React.string}
      <Toolkit.Ui.Button
        size=#xs
        onClick={_ =>
          setState(Some({code: codeExample, title: "With decco : Example 2 (decoding failure)"}))}>
        {"See the code"->React.string}
      </Toolkit.Ui.Button>
    </h3>
    <div className="flex flex-col items-start gap-4 mt-2">
      <Toolkit.Ui.Button
        color=#primary
        isLoading={request === Loading}
        onClick={_ => {
          setRequest(_ => Loading)
          fetchDeliveries()
          ->Js.Promise2.then(res => {
            setRequest(_ => res)
            Js.Promise2.resolve()
          })
          ->ignore
        }}>
        {"Do the request"->React.string}
      </Toolkit.Ui.Button>
      {switch request {
      | Idle => React.null
      | Loading => "loading..."->React.string
      | Done(_) => React.null
      | Error(DecodeError(err)) =>
        <div>
          <p className="text-danger-500"> {"Decoding error"->React.string} </p>
          <pre> {err->Obj.magic->Js.Json.stringifyWithSpace(2)->React.string} </pre>
        </div>
      | Error(_) =>
        <div>
          <p className="text-danger-500"> {"An error occured"->React.string} </p>
        </div>
      }}
    </div>
  </div>
}
