let worker = Msw.setupWorker([
  Msw.Rest.get("https://someapi.com/deliveries", (_req, res, ctx) => {
    let response = Array.makeBy(5, i => {
      WithoutDecco__Example1.id: i->Int.toString,
      address: "address",
      country: None,
      clientName: i < 5 ? Js.Nullable.return("clientName") : Js.Nullable.null,
      timeslot: {
        start: "10h",
        end: "12h",
      },
    })
    res(Msw.Ctx.json(ctx, response))
  }),
  Msw.Rest.get("https://someapi.com/deliveriesFail", (_req, res, ctx) => {
    let response = Array.makeBy(5, i => {
      WithoutDecco__Example1.id: i->Int.toString,
      address: 1->Obj.magic, // oh no!
      country: None,
      clientName: i < 5 ? Js.Nullable.return("clientName") : Js.Nullable.null,
      timeslot: {
        start: "10h",
        end: "12h",
      },
    })
    res(Msw.Ctx.json(ctx, response))
  }),
  Msw.Rest.get("https://someapi.com/deliveriesDecode", (_req, res, ctx) => {
    let response = Array.makeBy(5, i => {
      WithDecco__Example3.id: i->Int.toString,
      address: "address",
      country: None,
      clientName: i < 5 ? Some("clientName") : None,
      energyType: i < 5 ? #electric : #gas,
      timeslot: {
        start: Js.Date.make(),
        end: Js.Date.make(),
      },
    })
    res(Msw.Ctx.json(ctx, response))
  }),
  Msw.Rest.get("https://someapi.com/special", (_req, res, ctx) => {
    let response = Array.makeBy(10, i => {
      WithoutDecco__Example2.uniqueId: i->Int.toString,
      phone: i > 5 ? Some("0320000" ++ i->Int.toString) : None,
      name: i < 5 ? Some(Js.Nullable.return("client n°" ++ i->Int.toString)) : None,
      type_: mod(i, 2) === 0 ? #element1 : #element2,
    })
    res(Msw.Ctx.json(ctx, response))
  }),
])

@val
external isProduction: bool = "import.meta.env.PROD"

let init = () => {
  worker->Msw.start({
    isProduction
      ? {
          serviceWorker: {
            url: "/colisweb-rescript-api-parse/mockServiceWorker.js",
          },
        }
      : {}
  })
}
