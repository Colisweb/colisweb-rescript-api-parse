open! Utils

module Date = {
  type date = Js.Date.t

  let encoder: Decco.encoder<date> = date =>
    date->DateFns.formatWithPattern("yyyy-MM-dd")->Decco.stringToJson

  let decoder: Decco.decoder<date> = json =>
    switch Decco.stringFromJson(json) {
    | Ok(v) => Js.Date.fromString(v)->Ok
    | Error(_) as err => err
    }

  let codec: Decco.codec<date> = (encoder, decoder)

  @decco
  type t = @decco.codec(codec) date
}

module type EnumConfig = {
  type enum
  let enumFromJs: string => option<enum>
  let enumToJs: enum => string
}
module MakeEnum = (Config: EnumConfig) => {
  %%private(
    let encoder = value => value->Config.enumToJs->Decco.stringToJson

    let decoder = json =>
      switch Decco.stringFromJson(json) {
      | Ok(value) =>
        switch Config.enumFromJs(value) {
        | None => Decco.error(~path="", "Invalid enum " ++ value, json)
        | Some(value) => Ok(value)
        }
      | Error(_) as error => error
      }

    let codec = (encoder, decoder)
  )

  let toString = Config.enumToJs
  let fromString = Config.enumFromJs

  @decco
  type t = @decco.codec(codec) Config.enum
}

module DeliveryEnergyType = MakeEnum({
  @deriving(jsConverter)
  type enum = [
    | #electric
    | #gas
  ]
})

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
  energyType: DeliveryEnergyType.t,
}
@decco
and timeslot = {
  start: Date.t,
  end: Date.t,
}

let fetchDeliveries = async () => {
  await wait(2000)

  try {
    let response = await Axios.get("http://someapi.com/deliveriesDecode")
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

@module("@root/src/example-with-decco/WithDecco__Example3.res?raw")
external codeExample: string = "default"

@react.component
let make = () => {
  let (request, setRequest) = React.useState((): request<deliveriesResponse, 'a> => Idle)
  let {setState} = React.useContext(CodeBlock.Context.context)

  <div>
    <h3 className="text-lg text-slate-500 flex flex-row items-center gap-2">
      {"Example 3 Date & Enum decoding"->React.string}
      <Toolkit.Ui.Button
        size=#xs
        onClick={_ =>
          setState(
            Some({code: codeExample, title: "With decco : Example 3 Date & Enum decoding"}),
          )}>
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
      | Done(deliveries) =>
        <div>
          <h4 className="text-sm text-slate-700"> {"Request results"->React.string} </h4>
          <div className="flex flex-row gap-2 flex-wrap">
            {deliveries
            ->Array.map(({clientName, id, timeslot, energyType}) => {
              <div key={id} className={"text-sm border p-1 rounded"}>
                <p> {`#${id}`->React.string} </p>
                <p> {clientName->Option.getWithDefault("-")->React.string} </p>
                <div>
                  <strong> {"Timeslot"->React.string} </strong>
                  <p> {`start: ${timeslot.start->Js.Date.toDateString}`->React.string} </p>
                  <p> {`end: ${timeslot.end->Js.Date.toDateString}`->React.string} </p>
                </div>
                <div>
                  <strong> {"Energy type"->React.string} </strong>
                  <p> {energyType->DeliveryEnergyType.toString->React.string} </p>
                </div>
              </div>
            })
            ->React.array}
          </div>
        </div>
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
