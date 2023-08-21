@val
external copyToClipboard: string => unit = "navigator.clipboard.writeText"

HighlightJs.registerLanguage("rescript", HighlightJs.rescriptModule)

module Context = {
  type codeContext = {
    code: string,
    title: string,
  }

  type context = {
    state: option<codeContext>,
    setState: option<codeContext> => unit,
  }

  let context: React.Context.t<context> = React.createContext({
    state: None,
    setState: _ => (),
  })

  module Provider = {
    let make = React.Context.provider(context)
  }
}

@react.component
let make = (~code, ~title) => {
  <div className="Code border w-[800px] h-full overflow-auto z-40 shadow-lg flex-shrink-0">
    <div className="border-b p-4">
      <h2 className="text-xl font-semibold"> {title->React.string} </h2>
      <button
        className="absolute right-0 top-0 bg-white rounded-tl rounded-b text-lg px-2 border-b border-l hover:bg-neutral-200"
        onClick={_ => copyToClipboard(Obj.magic(code))}>
        {"Copy"->React.string}
      </button>
    </div>
    <pre className="p-4">
      <code
        dangerouslySetInnerHTML={
          "__html": HighlightJs.highlight(code, {"language": "rescript"}).value,
        }
      />
    </pre>
  </div>
}
