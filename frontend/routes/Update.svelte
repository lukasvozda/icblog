<script>

    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"
    
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
            post.tags = post.tags.join(",")
        } else {
            // failed to update the post
            message = "Post couldn't be updated: " + Object.keys(res.err)[0]
            status = "err"
        }
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
            <form>
                <label for="title">Post title:</label>
                <input type="text" name="title" id="nime" bind:value="{post.title}" required><br>
                <label for="content">Post description:</label>
                <input type="text" name="description" bind:value="{post.description}" maxlength="300" required><br>
                <label for="content">Post content:</label>
                <textarea name="content" bind:value="{post.content}" rows="40" cols="50" required></textarea><br>
                <label for="tags">Tags (comma separated):</label>
                <input type="text" name="tags" bind:value="{post.tags}"><br>
                <label>
                    <input type=checkbox bind:checked={post.published}>
                    Published
                </label><br>
                <div class="message {status}">{message}</div>
                
                <button type="submit" class="update" on:click={updatePost} disabled={loading}>
                    {#if loading === true}
                        Loading...
                    {:else}
                        Update post
                    {/if}
                </button> 
            </form>
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

.message {
    margin-top: 20px;
    float: left;
    font-weight: bold;
}

.err {
    color:crimson;
}

.ok {
    color:rgb(0, 173, 116);
}

input[type=text],
select,
textarea {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
    white-space: pre-wrap;
}
input:focus, textarea:focus {
  background-color:azure;
  outline:none;
  border: 1px solid #a02480;
}
.update {
    color: #a02480;
    padding: 10px 20px;
    text-decoration: none;
    margin: 5px;
    border-radius: 40px;
    background-color: aquamarine;
    margin-top: 10px;
    font-size: 18px;
    float: right;
    cursor: pointer;
    border: none;
    font-weight: bold;
}

.update:hover {
    text-decoration: underline;
}

</style>

