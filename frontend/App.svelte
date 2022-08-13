<script>
  /*
   * Connect2ic provides essential utilities for IC app development
   */
  import { createClient } from "@connect2ic/core"
  import { defaultProviders } from "@connect2ic/core/providers"
  import { ConnectButton, ConnectDialog, Connect2ICProvider } from "@connect2ic/svelte"
  import "@connect2ic/core/style.css"
  
  /*
   * Import canister definitions like this:
   */
  import * as blog from "../.dfx/local/canisters/blog"

  /*
   * Svelte router import so we can add custom URLS
   */
  import { Router, Link, Route } from "svelte-navigator";
  import About from "./routes/About.svelte";
  import Home from "./routes/Home.svelte";
  import Create from "./routes/Create.svelte";
  import Detail from "./routes/Detail.svelte";
  import Update from "./routes/Update.svelte";
  import Delete from "./routes/Delete.svelte";

  // Connect2ic client
  const client = createClient({
    canisters: {
      blog,
    },
    providers: defaultProviders,
    globalProviderConfig: {
      dev: import.meta.env.DEV,
    },
  });
</script>

<Connect2ICProvider client={client}>
  <div class="App">
    <div class="auth-section">
      <ConnectButton />
    </div>
    <ConnectDialog />
    <Router>
      <header>
          <nav id="nav">
              <a href="/" class="logo">
                  IC Blogsite
              </a>
              <Link class="nav-link" to="/">Home</Link>
              <Link class="nav-link" to="about">About</Link>
          </nav>
      </header>
      <div class="content">
          <Route path="/" component={Home} />
          <Route path="about" component={About} />
          <Route path="create" component={Create} />
          <Route path="post/:id" component="{Detail}" /> <!-- Dynamic routes for post detail, update and delete-->
          <Route path="update/:id" component="{Update}" /> 
          <Route path="delete/:id" component="{Delete}" /> 
      </div>
    </Router>
  </div>
</Connect2ICProvider>

<style global> 
  /* 
    Global styles
  */*
  body {
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
      "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
      sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      color: #424242;
  }

  button {
      font-weight: 600;
  }

  nav {
    padding: 1em;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    text-align: left;
    position: fixed;
    top: 0;
    left: 0;
    background-color: white;
    z-index: 99999;
  }

  .logo {
    font-size: 120%;
    padding: 10px;
    font-weight: bold;
    text-decoration: none;
    color:#a02480;
  }

  .nav-link {
    padding: 10px;
    color: black;
    text-decoration: none;
  }

  .nav-link:hover {
    text-decoration: underline;
    transition: 0.4s ease;
  }

  a[aria-current]{
      text-decoration: underline;
  }

  a {
    color: #07167b;
    text-decoration: none;
  }

  a:hover {
      text-decoration: underline;
  }

  .content {
    position: relative;
    text-align:  center;
    justify-content: center;
    margin-top: 100px;
    min-height: 500px;
    
  }

  h1:focus { 
    outline: none;
  }

  .auth-section {
      padding: 1em;
      display: flex;
      justify-content: flex-end;
      align-items: center;
      text-align: right;
      position: fixed;
      top: 0;
      right: 0;
  }
  .message {
    margin-top: 20px;
    float: left;
    font-weight: bold;
  }

  .err {
    color: crimson;
  }

  .ok {
    color: rgb(0, 173, 116);
  }

  .ql-toolbar {
    margin-top: 10px;
  }

  .edit,
  .delete {
      color: #07167b;
      padding: 10px 20px;
      text-decoration: none;
      margin: 5px;
      border-radius: 40px;
      font-weight: bold;
  }

  .edit:hover,
  .delete:hover {
      text-decoration: underline;
  }

  .edit {
      background-color: aquamarine;
  }

  .delete {
      background-color: burlywood;
  }

  img {
    max-width: 100%;
  }
</style>
