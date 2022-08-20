<script>
    import { useParams } from "svelte-navigator";
    import { useConnect, useCanister } from "@connect2ic/svelte"
    import { onMount } from "svelte";
    import { Link } from "svelte-navigator";
    import { marked } from 'marked';
    import Loader from "../components/Loader.svelte"

    let loading = false

    // Anonymous mode is enough for post reading
    const [blog] = useCanister("blog", { mode: "anonymous" })

    const { isConnected } = useConnect() // Getting isConnected attribute from the connect2ic module so we know whether user is authenticated with wallet

    const params = useParams();

    let postId = parseInt($params.id); // Get post ID from the URL
    console.log($params.id)

    let post = {}

    const getPost = async () => {
        loading = true
        const res = await $blog.get(postId)
        if("ok" in res){
            post = res.ok
        } else {
            console.log(Object.keys(res.err)[0])
            post = {
                title: Object.keys(res.err)[0],
                content: ""
            }
        }
        loading = false
    }

    // Function that converts unix timestamp to readebla date
    function getDate(timestamp) {
        var converted = Number(timestamp) / 1000000;
        var date = new Date(converted);
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).substr(-2);
        var day = ("0" + date.getDate()).substr(-2);

        return year + "-" + month + "-" + day ;
    }

    onMount(getPost)
</script>

<h1>{post.title || 'Loading'}</h1>
<div class="back">
    <Link to="/">Go back</Link>
</div>  
<div class="author">Written by: {post.author}  </div>
<div class="date">Last updated: {getDate(post.time_updated)}</div>
<div class="date">Date created: {getDate(post.time_created)}</div>
<div class="tags">
    {#if post.tags}
        {#each post.tags as tag}
            <span class="tag">#{tag}</span>
        {/each}
    {/if}
</div>
{#if $isConnected} <!-- Only authenticated users can Edit or Delete posts-->
    <Link to="/update/{postId}" class="edit">Edit</Link>
    <Link to="/delete/{postId}" class="delete">Delete</Link>
{:else}
    <div>Connect your wallet to edit or delete post.</div>
{/if}
<div class="posts">
    <div class="post">
        <div id="post-content">
            {@html marked(post.content || "Loading")} <!-- Render post content as HTML not as text -->
        </div>
    </div>

</div>    
<Loader loading={loading} />
<style>
        .posts {
            text-align: center;
            width: 500px;
            max-width: 90%;
            float: none;
            margin-left: auto;
            margin-right: auto;
            margin-top: 50px;

        }

        .post {
            text-align: left;
            display: block;
            white-space: pre-wrap;

        }

        .author,
        .date {
            font-size: 80%;
            color: gray;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .tags {
            font-size: 80%;
            margin-bottom: 30px;
        }

        .tag {
            margin-right: 5px;
            color: gray;
        }
</style>