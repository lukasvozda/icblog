<script>
    import { useConnect, useCanister } from "@connect2ic/svelte"
    import { onMount } from "svelte"
    import Loader from "../components/Loader.svelte"
    const [blog] = useCanister("blog", { mode: "anonymous" })

    let loading = true;

    const { isConnected, principal, activeProvider } = useConnect({
        onConnect: () => {
        // Signed in
        },
        onDisconnect: () => {
        // Signed out
        }
    })

    let posts = []

    const get_all_posts = async () => {
        //loading = true
        const res = await $blog.list_array()
        console.log(res)
        posts = res
        loading = false
        return posts
    }

    const create_test = async () => {
        console.log("create_test")
        //console.log("loading")
        //loading = true
        const res = await $blog.create_test()
        //loading = false
        console.log(res.toString())
        console.log("creating finished")
        //get_post()
        get_all_posts()
        
    }

    function getDate(timestamp) {
        var converted = Number(timestamp) / 1000000;
        var date = new Date(converted);
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).substr(-2);
        var day = ("0" + date.getDate()).substr(-2);


        return year + "-" + month + "-" + day ;
    }

    onMount(get_all_posts)
</script>
<h1>Sample blog app</h1>
<div>
    {#if $isConnected}
        <p>Wallet principal: <span style="font-size: 0.7em">{$principal}</span></p>
        <a href="/create" class="create">Create a post</a>
    {:else}
        <p class="example-disabled">Connect with a wallet to create a post</p>
    {/if}
</div>
<div class="posts">

    {#each posts as post }
    <!-- <li>{post[0]} - {post[1].title} <button on:click={() => delete_post(post[0])} class="x">x</button></li> -->
    <div class="post">
        <a href="/post/{post[0]}"><h2 class="post-title">{post[1].title}</h2></a>
        <div class="author">Written by: {post[1].author}  </div>
        <div class="post-description">
            {post[1].description}
        </div>
        <div class="date">Last updated: {getDate(post[1].time_updated)}</div>
        <div class="tags">
            {#each post[1].tags as tag}
                <span class="tag">#{tag}</span>
            {/each}
        </div>
    </div>
    {/each}
</div>

<Loader loading={loading} />

<style>
    h1 {
        display: block;
    }

    a {
        color: #a02480;;
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }

    .posts {
        text-align: center;
        width: 500px;
        float: none;
        margin-left: auto;
        margin-right: auto;
        margin-top: 100px;

    }

    .post {
        text-align: left;
        display: block;
        border-bottom: 1px solid #a02480;
   
    }

    .author, .date {
        font-size: 80%;
        color: gray;
        margin-top: 10px;
        margin-bottom: 10px;
    }

    .tags {
        font-size: 80%;
        margin-bottom: 5px;
    }

    .tag {
        margin-right: 5px;
        color: gray;
    }

</style>