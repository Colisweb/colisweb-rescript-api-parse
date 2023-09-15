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
          <div className="flex flex-row gap-2 text-xs">
            <span> {"by Thomas Deconinck"->React.string} </span>
            <a href="https://colisweb.com" className="underline"> {"@colisweb"->React.string} </a>
            <a href="https://github.com/Colisweb/colisweb-rescript-api-parse" className="underline">
              {"Check the code on Github"->React.string}
            </a>
          </div>
        </div>
        <ExampleWithoutDecco />
        <ExampleWithDecco />
      </div>
      {codeExample->Option.mapWithDefault(React.null, ({code, title}) => <CodeBlock code title />)}
    </div>
  </CodeBlock.Context.Provider>
}
