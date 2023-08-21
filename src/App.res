@react.component
let make = () => {
  let (codeExample, setCodeExample) = React.useState(() => None)

  React.useEffect0(() => {
    Mocks.init()

    None
  })

  <CodeBlock.Context.Provider
    value={{
      state: codeExample,
      setState: c => setCodeExample(_ => c),
    }}>
    <div className="flex flex-row bg-slate-100 h-full">
      <div className=" p-4 flex flex-col gap-4 w-full">
        <ExampleWithoutDecco />
        <ExampleWithDecco />
      </div>
      {codeExample->Option.mapWithDefault(React.null, ({code, title}) => <CodeBlock code title />)}
    </div>
  </CodeBlock.Context.Provider>
}
