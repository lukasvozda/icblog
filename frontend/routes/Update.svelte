<script>

    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"
    import Form from "../components/Form.svelte"
    
    //const [blog] = useCanister("blog")
    const [blog] = useCanister("blog", { mode: "anonymous" })

    const params = useParams();

    let postId = parseInt($params.id);

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
        post.tags = post.tags.replace(" ", "").split(",")
        const res = await $blog.update(postId, post)
        if ("ok" in res) {
            message = "Post was successfully updated!"
            status = "ok"
        } else {
            // failed to update the post
            message = "Post couldn't be updated: " + Object.keys(res.err)[0]
            status = "err"
        }
        post.tags = post.tags.join(",")
        loading = false
        return res
    }
    onMount(getPost)
</script>

<h1>Update post: {post.title}</h1>
<div class="back">
    <a href="/post/{postId}">Go back</a>
</div>  
<div class="posts">
    <div class="post">
        <div>
            <Form loading={loading} post={post} submit_function={updatePost}/>
            <div class="message {status}">{message}</div>
        </div>
    </div>
</div>

<Loader loading={loading} />

<style>

.posts {
    text-align: center;
    width: 500px;
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

