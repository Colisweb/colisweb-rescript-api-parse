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
        <div>
          <h1 className="text-xl font-semibold">
            {"How to parse an API with ReScript"->React.string}
          </h1>
          <small>
            {"by Thomas Deconinck"->React.string}
            <a href="https://colisweb.com" className="underline ml-1">
              {"@colisweb"->React.string}
            </a>
          </small>
        </div>
        <ExampleWithoutDecco />
        <ExampleWithDecco />
      </div>
      {codeExample->Option.mapWithDefault(React.null, ({code, title}) => <CodeBlock code title />)}
    </div>
  </CodeBlock.Context.Provider>
}
