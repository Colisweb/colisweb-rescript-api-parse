@react.component
let make = () => {
  <Toolkit.Ui.Card>
    <Toolkit.Ui.Card.Header> {"Example without decco"->React.string} </Toolkit.Ui.Card.Header>
    <Toolkit.Ui.Card.Body>
      <div className="flex flex-col gap-8">
        <WithoutDecco__Example1 />
        <WithoutDecco__Example2 />
        <WithoutDecco__Example2Bis />
      </div>
    </Toolkit.Ui.Card.Body>
  </Toolkit.Ui.Card>
}
