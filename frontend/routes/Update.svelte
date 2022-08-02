<script>

    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"
    
    //const [blog] = useCanister("blog")
    const [blog] = useCanister("blog", { mode: "anonymous" })

    const params = useParams();

    let postId = parseInt($params.id);
    console.log($params.id)

    let post = {}

    let postTitle = ""
    let postContent = ""
    let postDescription = ""
    let postPublished = false
    let postTags = ""
    let loading = false


    const get_post = async () => {
        loading = true
        console.log("Gettin post: " + postId)
        const res = await $blog.get(postId)
        console.log(res)
        post = res[0]
        if (post) {
            // TODO maybe will be better to do it object-like
            console.log(post)
            postTitle = post.title
            postContent = post.content
            postDescription = post.description
            postPublished = post.published
            postTags = post.tags.join(",")
        } else {
            console.log("Post not found")
            post = {
                title: "<Post not found>",
                content: "<No content>"
            }
        }
        console.log(postTags)
        loading = false
        return post
    }

    const updatePost = async () => {
        loading = true
        let post = {
            title: postTitle,
            content: postContent,
            description: postDescription,
            // time_created: 0, 
            // time_updated: 0,
            published: postPublished,
            // author: principal,
            tags: postTags.split(","),
        }
        console.log("creating a post: " + postTitle)
        const res = await $blog.update(postId, post)
        console.log(res)
        // if (res) {
        //     posts.push([res, post])
        // }
        loading = false
        return res
    } 

    onMount(get_post)
</script>

<h1>Update post: {post.title}</h1>
<div class="posts">
    <div class="post">
        <div>
            <form>
                <label for="title">Post title:</label>
                <input type="text" name="title" id="nime" bind:value="{postTitle}" required><br>
                <label for="content">Post description:</label>
                <input type="text" name="description" bind:value="{postDescription}" maxlength="300" required><br>
                <label for="content">Post content:</label>
                <textarea name="content" bind:value="{postContent}" rows="40" cols="50" required></textarea><br>
                <label for="tags">Tags (comma separated):</label>
                <input type="text" name="tags" bind:value="{postTags}"><br>
                <label>
                    <input type=checkbox bind:checked={postPublished}>
                    Published
                </label><br>


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

