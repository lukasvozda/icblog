<script>
  import logo from "./assets/dfinity.svg"
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
   * Some examples to get you started
   */
  // import Counter from "./components/Counter.svelte"
  // import Profile from "./components/Profile.svelte"

  /*
   * Svelte router import so we can add custom URLS
   */
  import { Router, Link, Route } from "svelte-navigator";
  import About from "./routes/about.svelte";
  import Home from "./routes/Home.svelte";
  import Create from "./routes/Create.svelte";
  import Detail from "./routes/Detail.svelte";
  import Update from "./routes/Update.svelte";

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
              <!-- <Auth /> We will use pluge login -->
          </nav>
      </header>
      <div class="content">
          <Route path="/" component={Home} answer={42} />
          <Route path="about" component={About} />
          <Route path="create" component={Create} />
          <Route path="post/:id" component="{Detail}" /> 
          <Route path="update/:id" component="{Update}" /> 
      </div>
  </Router>
    <!-- <div class="examples">
      <Counter />
      <Profile />
    </div> -->
  </div>
</Connect2ICProvider>

<style global>
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

    .content {
      text-align:  center;
      justify-content: center;
      margin-top: 100px;
      
    }

    h1:focus { 
      outline: none;
    }

    .examples {
        padding: 30px 100px;
        display: grid;
        grid-gap: 30px;
        grid-template-columns: 1fr 1fr 1fr;
    }

    .examples-title {
        font-size: 1.3em;
        margin-bottom: 0;
        text-align: center;
    }

    .example {
        padding: 50px 50px;
        min-height: 300px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        /*border: 1px solid black;*/
        /*background: #f4f4f4;*/
        border-radius: 15px;
    }


    .demo-button {
        background: #a02480;
        padding: 0 1.3em;
        margin-top: 1em;
        border-radius: 60px;
        font-size: 0.7em;
        height: 35px;
        outline: 0;
        border: 0;
        cursor: pointer;
        color: white;
    }

    .demo-button:active {
        color: white;
        background: #979799;
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
</style>
