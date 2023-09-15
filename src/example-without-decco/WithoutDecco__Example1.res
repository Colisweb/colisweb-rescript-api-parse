open! Utils

@module("@root/src/example-with-decco/WithDecco__Example1.res?raw")
external codeExample: string = "default"

type rec deliveriesResponse = array<delivery>
and delivery = {
  id: string,
  address: string,
  country: option<string>,
  clientName: Js.Nullable.t<string>,
  timeslot: timeslot,
}
and timeslot = {
  start: string,
  end: string,
}

let fetchDeliveries = () => {
  wait(2000)->Js.Promise2.then(() => {
    Axios.get("https://someapi.com/deliveries")->Js.Promise2.then(response => {
      let deliveries: deliveriesResponse = response["data"]->Obj.magic

      Js.Promise2.resolve(deliveries)
    })
  })
}

@react.component
let make = () => {
  let (request, setRequest) = React.useState(() => Idle)
  let {setState} = React.useContext(CodeBlock.Context.context)

  <div>
    <h3 className="text-lg text-slate-500 flex flex-row items-center gap-2">
      {"Example 1"->React.string}
      <Toolkit.Ui.Button
        size=#xs
        onClick={_ => setState(Some({code: codeExample, title: "Without decco : example 1"}))}>
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
      </Toolkit.Ui.Button>
      {switch request {
      | Idle => React.null
      | Loading => "loading..."->React.string
      | Done(deliveries) =>
        <div>
          <h4 className="text-sm text-slate-700"> {"Request results"->React.string} </h4>
          <div className="flex flex-row gap-2 flex-wrap">
            {deliveries
            ->Array.map(({clientName, id}) => {
              <div key={id} className="text-sm border p-1 rounded">
                <p> {`#${id}`->React.string} </p>
                <p>
                  {clientName->Js.Nullable.toOption->Option.getWithDefault("-")->React.string}
                </p>
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
