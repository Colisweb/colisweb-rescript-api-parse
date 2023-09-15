open! Utils

@module("@root/src/example-without-decco/WithoutDecco__Example2.res?raw")
external codeExample: string = "default"

type rec response = array<special>
and special = {
  uniqueId: string,
  type_: specialType,
  name: option<Js.Nullable.t<string>>, // présent si type_ == "element1"
  phone: option<string>, // présent si type == "element2"
}
and specialType = [
  | #element1
  | #element2
]

let fetchSpecial = () => {
  wait(2000)->Js.Promise2.then(() => {
    Axios.get("https://someapi.com/special")->Js.Promise2.then(response => {
      let deliveries: response = response["data"]->Obj.magic

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
      {"Example 2"->React.string}
      <Toolkit.Ui.Button
        size=#xs
        onClick={_ => setState(Some({code: codeExample, title: "Without decco : example 2"}))}>
        {"See the code"->React.string}
      </Toolkit.Ui.Button>
    </h3>
    <div className="flex flex-col items-start gap-4 mt-2">
      <Toolkit.Ui.Button
        color=#primary
        isLoading={request === Loading}
        onClick={_ => {
          setRequest(_ => Loading)
          fetchSpecial()
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
      | Done(data) =>
        <div>
          <h4 className="text-sm text-slate-700"> {"Request results"->React.string} </h4>
          <div className="flex flex-row gap-2 flex-wrap">
            {data
            ->Array.map(({name, phone, uniqueId}) => {
              let name = name->Option.flatMap(Js.Nullable.toOption)->Option.getWithDefault("")
              let phone = phone->Option.getWithDefault("")

              <div key={uniqueId} className="text-sm border p-1 rounded">
                <p> {`Name: ${name}`->React.string} </p>
                <p> {`Phone: ${phone}`->React.string} </p>
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
