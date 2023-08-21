@react.component
let make = () => {
  <div className="bg-white p-4 rounded-lg shadow">
    <h2 className="text-lg font-bold border-b mb-4"> {"Example without decco"->React.string} </h2>
    <div className="flex flex-col gap-8">
      <WithoutDecco__Example1 />
      <WithoutDecco__Example2 />
      <WithoutDecco__Example2Bis />
    </div>
  </div>
}
