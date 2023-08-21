open! Utils

module Example1 = {
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
      Axios.get("http://someapi.com/deliveries")->Js.Promise2.then(response => {
        let deliveries: deliveriesResponse = response["data"]->Obj.magic

        Js.Promise2.resolve(deliveries)
      })
    })
  }

  @react.component
  let make = () => {
    let (request, setRequest) = React.useState(() => Idle)

    <div>
      <h3 className="text-lg text-slate-500"> {"Example 1"->React.string} </h3>
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
}
module Example2 = {
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
      Axios.get("http://someapi.com/special")->Js.Promise2.then(response => {
        let deliveries: response = response["data"]->Obj.magic

        Js.Promise2.resolve(deliveries)
      })
    })
  }

  @react.component
  let make = () => {
    let (request, setRequest) = React.useState(() => Idle)

    <div>
      <h3 className="text-lg text-slate-500"> {"Example 2"->React.string} </h3>
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
              ->Array.map(({name, phone, uniqueId}) => {
                let name = name->Option.flatMap(Js.Nullable.toOption)->Option.getWithDefault("")
                let phone = phone->Option.getWithDefault("")

                <div key={uniqueId}>
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
}
module Example2Bis = {
  @react.component
  let make = () => {
    let (request, setRequest) = React.useState(() => Idle)

    <div>
      <h3 className="text-lg text-slate-500"> {"Example 2 bis"->React.string} </h3>
      <div className="flex flex-col items-start gap-4">
        <button
          className="px-2 py-1 rounded bg-slate-100"
          onClick={_ => {
            setRequest(_ => Loading)
            Example2.fetchSpecial()
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
}

@react.component
let make = () => {
  <div className="bg-white p-4 rounded-lg shadow">
    <h2 className="text-lg font-bold border-b mb-4"> {"Example without decco"->React.string} </h2>
    <div className="flex flex-col gap-8">
      <Example1 />
      <Example2 />
      <Example2Bis />
    </div>
  </div>
}
