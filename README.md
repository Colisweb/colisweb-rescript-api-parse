# vite-template-rescript

Clone this project `git clone --depth 1 git@gitlab.com:colisweb/front/vite-template-rescript.git`

## Getting Started

**Replace all `vite-template-rescript` with your project name;**

Add `NPM_TOKEN` to your `.zschrc`

```
export NPM_TOKEN="xxx"
```

Set the npm registry with the token

```
npm config set //registry.npmjs.org/:_authToken ${NPM_TOKEN}
```

Install dependencies

```sh
yarn
```

Run in development

```sh
yarn dev
```

## Associated projects

- [api](https://gitlab.com/colisweb/front/api)
- [rescript-toolkit](https://gitlab.com/colisweb-open-source/rescript-toolkit)

## Use a gitlab branch with npm

rescript-toolkit

```json
{
  "@colisweb/rescript-toolkit": "git+ssh://git@gitlab.com:colisweb-open-source/rescript-toolkit.git#vite"
}
```

api

```json
{
  "@colisweb/api": "git+ssh://git@gitlab.com:colisweb/front/api.git#create_user_error_password"
}
```
