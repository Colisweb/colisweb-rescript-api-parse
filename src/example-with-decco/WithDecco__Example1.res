open! Utils

@decco
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

let fetchDeliveries = () => {
  wait(2000)->Js.Promise2.then(() => {
    Axios.get("http://someapi.com/deliveries")->Js.Promise2.then(response => {
      let deliveriesDecoding = response["data"]->deliveriesResponse_decode

      switch deliveriesDecoding {
      | Ok(deliveries) => Js.Promise2.resolve(deliveries)
      | Error(decodingError) => {
          Js.log(decodingError)
          Js.Promise2.reject(#decodingError->Js.Exn.anyToExnInternal)
        }
      }
    })
  })
}

@module("@root/src/example-with-decco/WithDecco__Example1.res?raw")
external codeExample: string = "default"

@react.component
let make = () => {
  let (request, setRequest) = React.useState(() => Idle)
  let {setState} = React.useContext(CodeBlock.Context.context)

  <div>
    <h3 className="text-lg text-slate-500 flex flex-row items-center gap-2">
      {"Example 1"->React.string}
      <button
        className="text-sm border px-1 rounded hover:bg-blue-500 hover:text-white hover:border-blue-500"
        onClick={_ => setState(Some({code: codeExample, title: "With decco : Example 1"}))}>
        {"See the code"->React.string}
      </button>
    </h3>
    <div className="flex flex-col items-start gap-4">
      <button
        className="px-2 py-1 rounded bg-slate-100"
        onClick={_ => {
          setRequest(_ => Loading)
          fetchDeliveries()
          ->Js.Promise2.then(data => {
            setRequest(_ => Done(data))
            Js.Promise2.resolve()
          })
          ->Js.Promise2.catch(err => {
            setRequest(_ => Error(err))
            Js.Promise2.reject(RequestError)
          })
          ->ignore
        }}>
        {"Do the request"->React.string}
      </button>
      {switch request {
      | Idle => React.null
      | Loading => "loading..."->React.string
      | Done(deliveries) =>
        <div>
          <h4 className="text-sm text-slate-700"> {"Request results"->React.string} </h4>
          <div className="flex flex-row gap-2 flex-wrap">
            {deliveries
            ->Array.map(({clientName, id}) => {
              <div key={id} className="text-sm border p-1 rouded">
                <p> {`#${id}`->React.string} </p>
                <p> {clientName->Option.getWithDefault("-")->React.string} </p>
              </div>
            })
            ->React.array}
          </div>
        </div>
      | Error(_) => <p className="text-red-500"> {"An error occured"->React.string} </p>
      }}
    </div>
  </div>
}
