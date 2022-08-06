<script>
    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"
    
    //const [blog] = useCanister("blog")
    const [blog] = useCanister("blog", { mode: "anonymous" })

    const { isConnected, principal } = useConnect()

    const params = useParams();

    let postId = parseInt($params.id);
    console.log($params.id)

    let post = {}
    let loading = false
    let status = ""
    let message = ""

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
        const res = await $blog.delete(postId)
        console.log(res)
        if ("ok" in res){
            message = "Post was successfully deleted"
            status = "ok"
        } else {
            message = "Post couldn't be deleted: " + Object.keys(res.err)[0]
            status = "err"
        }
        loading = false
    }

    onMount(getPost)

</script>
{#if $isConnected && post.title} 
<h1>Delete post: {post.title||"Loading"}</h1>
<div class="question">Are you sure to delete this post?</div>
<a href="/post/{postId}">Go back</a>
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
    }

    .err {
        color: crimson;
    }

    .ok {
        color: rgb(0, 173, 116);
    }
</style>