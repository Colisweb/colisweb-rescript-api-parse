@react.component
let make = () => {
  <Toolkit.Ui.Card>
    <Toolkit.Ui.Card.Header> {"Example with decco"->React.string} </Toolkit.Ui.Card.Header>
    <Toolkit.Ui.Card.Body>
      <div className="flex flex-col gap-8">
        <WithDecco__Example1 />
        <WithDecco__Example2 />
        <WithDecco__Example3 />
      </div>
    </Toolkit.Ui.Card.Body>
  </Toolkit.Ui.Card>
}
