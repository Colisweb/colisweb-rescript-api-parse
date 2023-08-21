let mocks = [Mock__Auth.mocks]
let worker = Msw.setupWorker(mocks->Array.concatMany)
