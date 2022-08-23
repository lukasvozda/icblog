<script>
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import { Link } from "svelte-navigator";
    import Loader from "../components/Loader.svelte" // Loader animation
    import Form from "../components/Form.svelte" // Form component is shared for post Create and Update route

    // Use anonymouse mode only for local development
    // For production use, we want only users that signed with wallet to create/update/delete posts
    const [blog] = process.env.NODE_ENV == "production" ? useCanister("blog") : useCanister("blog", { mode: "anonymous" })

    // Get the isConnected value from the conenct2ic store so we know, whether user is connected
    const { isConnected } = useConnect() 

    let loading = false
    let status = ""
    let message = ""

    // This is our simplified post object, other attributes are going to be set in the back-end
    let post = {
        title: "",
        content: "",
        description: "",
        published: false,
        tags: ""
    }
    
    const createPost = async () => {
        loading = true
        post.tags = post.tags.replace(" ", "").split(",") // Convert tags from string to array
        const res = await $blog.create(post) // Create a post
        if("ok" in res){ // Post creation succeeded
            message = "Post was successfully created!"
            status = "ok"
        } else { // Post creation failed
            message = "Post couldn't be created: " + Object.keys(res.err)[0]
            status = "err"
        }
        post.tags = post.tags.join(",") // Convert tags back to string
        loading = false
    }
</script>

<h1>New blog post</h1>
<div class="back">
    <Link to="/">Go back</Link>
</div> 
<div class="posts">
    <div class="post">
        <div>
            {#if $isConnected}
                <Form loading={loading} post={post} submit_function={createPost}/>
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

}
.post {
    text-align: left;
    display: block;

}
</style>