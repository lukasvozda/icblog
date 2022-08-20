<script>
    import { useConnect, useCanister } from "@connect2ic/svelte"
    import { onMount } from "svelte"
    import { Link } from "svelte-navigator";
    import Loader from "../components/Loader.svelte"
    import logo from "../assets/dfinity.svg"

    const [blog ] = useCanister("blog", { mode: "anonymous" })

    let loading = true

    const { isConnected, principal } = useConnect({
        onConnect: () => {
            console.log("Connected!")
            list_posts(true) // List all posts for connected user
        },
        onDisconnect: () => {
            console.log("Disconnected!")
            list_posts(false) // List only published posts for disconnected user
        }
    })

    let posts = []

    const list_posts = async (connected) => {
        let res;
        if (connected || $isConnected) {
            res = await $blog.list_all() // List all posts
        } else {
            // List only published posts
            // We are doing this in the front end only as data are not sensitive, for 100 % security, we should verify principal in the backend too
            res = await $blog.list_published()
        }
        posts = res
        loading = false
        return posts
    }

    // Function that converts unix timestamp to readable date
    function getDate(timestamp) {
        var converted = Number(timestamp) / 1000000;
        var date = new Date(converted);
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).substr(-2);
        var day = ("0" + date.getDate()).substr(-2);


        return year + "-" + month + "-" + day;
    }

    onMount(list_posts)
</script>
<img src="{logo}" alt="">
<h1>Sample blog app</h1>
<div>
    {#if $isConnected}
        <p>Wallet principal: <span style="font-size: 0.7em">{$principal}</span></p>
        <Link to="/create" class="create">Create a post</Link> <!-- Only authenticated user can create a post -->
    {:else}
        <p class="example-disabled">Connect with a wallet to create a post.<br> You are able to see only published posts now.</p>
    {/if}
</div>
<div class="posts">
    {#each posts as post } <!-- Loop through each post -->
    <div class="post">
        <Link to="/post/{post[0]}"><h2 class="post-title">{post[1].title}</h2></Link>
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
        {#if post[1].published}
            <div class="published">Published</div>
        {:else}
            <div class="draft">Draft</div>
        {/if}
    </div>
    {/each}
</div>
<Loader loading={loading} />

<style>
    h1 {
        display: block;
    }

    .posts {
        text-align: center;
        width: 500px;
        max-width: 90%;
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

    .author, .date, .published, .draft {
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

    .published, .draft {
        text-align: right;
        margin-bottom: 10px;
    }

</style>