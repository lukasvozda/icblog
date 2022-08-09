# IC BLOG sample pp
This project was created as a sample app for the Internet Computer so new developers to the ecosystem have some working examples to learn from.

The project consist of a backend written in Motoko programming language, that has been designed specifically for writing smart contracts on the Internet Computer Protocol. Backend defines a Post type, HashMap database and methods for CRUD interace. 

It should give a quick start to anyone thinking about starting it's own blog site on the Internet Computer or just want to learn how to create a simple dapp.

I use Svelte starter app created by @miamaruq, he also created starter apps for React, Vue or TS. If you want to use different framework, you can find it here https://github.com/MioQuispe/create-ic-app. This starter app also utilizes the [Connect2IC toolkit](https://github.com/Connect2IC/connect2ic) that simplifies the process of wallet connection for different wallet providers.

## Local deployment 

We assume that you have:
- [Dfnity SDK](https://internetcomputer.org/docs/current/developer-docs/quickstart/hello10mins) installed
- NodeJS installed

Once you have cloned the repository, follow this process in your terminal:

```
run npm install (installs JS dependencies)
dfx start --background (or run it in separate terminal window)
dfx deploy (deploy your canister locally)
npm run dev (run local dev server)
```

### Deploy to the mainnet

If you have working local development replica, you can deploy your project to the mainnet by running this command:

dfx deploy --network ic

You are going to need a cycles wallet. Go through [this tutorial](https://internetcomputer.org/docs/current/developer-docs/quickstart/network-quickstart) to make it working.