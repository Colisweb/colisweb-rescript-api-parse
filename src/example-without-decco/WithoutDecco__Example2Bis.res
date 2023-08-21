open! Utils
open WithoutDecco__Example2

@react.component
let make = () => {
  let (request, setRequest) = React.useState(() => Idle)
  let {setState} = React.useContext(CodeBlock.Context.context)

  <div>
    <h3 className="text-lg text-slate-500 flex flex-row items-center gap-2">
      {"Example 2 bis"->React.string}
      <button
        className="text-sm border px-1 rounded hover:bg-blue-500 hover:text-white hover:border-blue-500"
        onClick={_ => setState(Some({code: codeExample, title: "Without decco : Example 2 bis"}))}>
        {"See the code"->React.string}
      </button>
    </h3>
    <div className="flex flex-col items-start gap-4">
      <button
        className="px-2 py-1 rounded bg-slate-100"
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
      </button>
      {switch request {
      | Idle => React.null
      | Loading => "loading..."->React.string
      | Done(data) =>
        <div>
          <h4 className="text-sm text-slate-700"> {"Request results"->React.string} </h4>
          <div className="flex flex-row gap-2 flex-wrap">
            {data
            ->Array.map(({type_, name, phone, uniqueId}) => {
              let name = name->Option.flatMap(Js.Nullable.toOption)

              <div key={uniqueId} className="border text-sm p-1 rounded">
                <small> {(type_ :> string)->React.string} </small>
                {switch (type_, name, phone) {
                | (#element1, Some(name), _) => <p> {`Name: ${name}`->React.string} </p>
                | (#element2, _, Some(phone)) => <p> {`Phone: ${phone}`->React.string} </p>
                | _ => <p className="text-xxs"> {"oops, a field didn't match"->React.string} </p>
                }}
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
