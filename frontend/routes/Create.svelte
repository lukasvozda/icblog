<script>
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"

    //const [blog] = useCanister("blog")
    const [blog] = useCanister("blog", { mode: "anonymous" })

    let post = {
        title: "",
        content: "",
        description: "",
        published: false,
        tags: ""
    }

    let loading = false

    const createPost = async () => {
        loading = true
        post.tags = post.tags.replace(" ", "").split(",")
        
        const res = await $blog.create(post)
        console.log(res)
        // if (res) {
        //     posts.push([res, post])
        // }
        loading = false
        return res
    } 
</script>


<h1>New blog post</h1>
<div class="posts">
    <div class="post">
        <div>
            <form>
                <label for="title">Title:</label>
                <input type="text" name="title" id="nime" bind:value="{post.title}" placeholder="Hellow World!"
                    required><br>
                <label for="content">Description:</label>
                <input type="text" name="description" bind:value="{post.description}" maxlength="300"
                    placeholder="Short description, max 300 characters." required><br>
                <label for="content">Content:</label>
                <textarea name="content" bind:value="{post.content}" rows="40" cols="50"
                    placeholder="What are you going to write about?" required></textarea><br>
                <label for="tags">Tags (comma separated):</label>
                <input type="text" name="tags" bind:value="{post.tags}" placeholder="Motoko,Svelte"><br>
                <label>
                    <input type=checkbox bind:checked={post.published}>
                    Published
                </label><br>


                <button type="submit" class="create" on:click={createPost} disabled={loading}>
                    {#if loading === true}
                        Loading...
                    {:else}
                        Create post
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

}
.post {
    text-align: left;
    display: block;

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

input:focus,
textarea:focus {
    background-color: azure;
    outline: none;
    border: 1px solid #a02480;
}

.create {
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

.create:hover {
    text-decoration: underline;
}
</style>