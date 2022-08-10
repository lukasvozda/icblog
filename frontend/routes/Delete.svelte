<script>
    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import { Link } from "svelte-navigator";
    import Loader from "../components/Loader.svelte"
    
    // Use anonymouse mode only for local development
    // For production use, we want only users that signed with wallet to create/update/delete posts
    const [blog] = useCanister("blog")
    //const [blog] = useCanister("blog", { mode: "anonymous" })

    const { isConnected } = useConnect() 

    const params = useParams();

    let postId = parseInt($params.id); // Get post ID from the URL
    console.log($params.id)

    let post = {}
    let loading = false
    let status = ""
    let message = ""
    let deleted = true

    // Get the post that we want to delete
    const getPost = async () => {
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

    const deletePost = async () => {
        loading = true
        const res = await $blog.delete(postId) // Call delete function to the backend canister
        console.log(res)
        if ("ok" in res){ // Post delete succeeded
            message = "Post was successfully deleted"
            status = "ok"
            deleted = true
        } else { // Post delete failed
            message = "Post couldn't be deleted: " + Object.keys(res.err)[0] // error message
            status = "err"
        }
        loading = false
    }

    onMount(getPost)
</script>

{#if $isConnected && post.title} 
<h1>Delete post: {post.title||"Loading"}</h1>
<div class="question">Are you sure to delete this post?</div>
<Link to="/post/{postId}">Go back</Link>
<button type="submit" class="delete" on:click={deletePost} disabled={loading}>
    {#if loading === true}
        Loading...
    {:else}
        Delete post
    {/if}
</button> 
<div class="message {status}">{message}</div>
{:else}
You need to connect with a wallet do delete post
{/if}

<Loader loading={loading} />

<style>
    .question {
        font-size: 120%;
    }

    .delete {
        color: #a02480;
        padding: 10px 20px;
        text-decoration: none;
        margin: 20px;
        border-radius: 40px;
        font-size: 120%;
        ;
        border: none;
        background-color: burlywood;
        cursor: pointer;
    }

    .delete:hover {
        text-decoration: underline;
    }

    .message {
        margin-top: 20px;
        font-weight: bold;
        display: block;
        width: 100%;
    }

    .err {
        color: crimson;
    }

    .ok {
        color: rgb(0, 173, 116);
    }
</style>