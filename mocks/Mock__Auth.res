let adminUser: ColiswebApi.Auth.user = {
  id: "1",
  username: "admin-mock",
  transporterId: None,
  clientId: None,
  storeId: None,
  carrierId: None,
  groups: ["admin"],
}
let transporterUser: ColiswebApi.Auth.user = {
  id: "2",
  username: "transpo-mock",
  transporterId: Some(Identifiers.TransporterId.make("9")),
  clientId: None,
  storeId: None,
  carrierId: None,
  groups: ["transporter"],
}
let storeUser: ColiswebApi.Auth.user = {
  id: "3",
  username: "store-mock",
  transporterId: None,
  clientId: Some(Identifiers.ClientId.make("5")),
  storeId: Some(Identifiers.StoreId.make("5")),
  carrierId: None,
  groups: ["store"],
}

let mocks = [
  Msw.Rest.post("https://login.testing.colisweb.com/api/session", (_req, res, ctx) => {
    let ex: ColiswebApi.Auth.CreateSession.Config.response = {
      firstIssuedAt: 10,
      issuedAt: 10,
      expiresAt: 10,
      issuer: "dunno",
      user: adminUser,
      role: #admin,
      isAdmin: true,
    }
    res(Msw.Ctx.json(ctx, ex))
  }),
  Msw.Rest.put("https://login.testing.colisweb.com/api/session", (_req, res, ctx) => {
    let ex: ColiswebApi.Auth.CreateSession.Config.response = {
      firstIssuedAt: 10,
      issuedAt: 10,
      expiresAt: 10,
      issuer: "dunno",
      user: adminUser,
      role: #admin,
      isAdmin: true,
    }

    res(Msw.Ctx.json(ctx, ex))
  }),
  // Msw.Rest.options("*", (_req, res, ctx) => {
  //   res([Msw.Ctx.set(ctx, "Access-Control-Allow-Origin", "*"), Msw.Ctx.json(ctx, Js.Dict.empty())])
  // }),
]
