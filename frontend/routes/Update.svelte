<script>
    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import { Link } from "svelte-navigator";
    import Loader from "../components/Loader.svelte"
    import Form from "../components/Form.svelte"
    
    // Use anonymouse mode only for local development
    // For production use, we want only users that signed with wallet to create/update/delete posts
    const [blog] = process.env.NODE_ENV == "production" ? useCanister("blog") : useCanister("blog", { mode: "anonymous" })

    const { isConnected } = useConnect() 

    const params = useParams()

    let postId = parseInt($params.id)

    let post = {}
    let loading = true
    let status = ""
    let message = ""

    const getPost = async () => {
        loading = true
        const res = await $blog.get(postId)
        if ("ok" in res) {
            post = res.ok
            post.tags = post.tags.join(",")
        } else {
            // failed to load the post
            post = {
                title: Object.keys(res.err)[0],
                content: ""
            }
        }
        loading = false
    }

    const updatePost = async () => {
        loading = true
        post.tags = post.tags.replace(" ", "").split(",") // Convert string with tags to array
        const res = await $blog.update(postId, post)
        if ("ok" in res) {
            message = "Post was successfully updated!"
            status = "ok"
        } else {
            // failed to update the post
            message = "Post couldn't be updated: " + Object.keys(res.err)[0]
            status = "err"
        }
        post.tags = post.tags.join(",") // Convert array back to string
        loading = false
        return res
    }
    onMount(getPost)
</script>
<h1>Update post: {post.title}</h1>
<div class="back">
    <Link to="/post/{postId}">Go back</Link>
</div>  
<div class="posts">
    <div class="post">
        <div>
            {#if $isConnected}
                <Form loading={loading} post={post} submit_function={updatePost}/>
                <div class="message {status}">{message}</div>
            {:else}
                You should connect with a wallet to be able to update this post.
            {/if}
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
    margin-bottom: 100px;

}

.post {
    text-align: left;
    display: block;
}
</style>

