@module("highlight.js") @scope("default")
external registerLanguage: (string, 'a) => unit = "registerLanguage"
@module("highlight.js") @scope("default")
external highlightAll: unit => unit = "highlightAll"

type result = {value: string}
@module("highlight.js") @scope("default")
external highlight: (string, 'a) => result = "highlight"

@module("@root/src/utils/rescript-highlight.js")
external rescriptModule: 'a = "default"
