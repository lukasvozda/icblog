<script>
    import { useCanister, useConnect } from "@connect2ic/svelte"
    
    const [blog] = useCanister("blog")

    let postTitle = ""
    let postContent = ""
    let postDescription = ""
    let postPublished = false
    let postTags = ""
    let loading = false

    const createPost = async () => {
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

<div>
    <label for="title">Post title:</label>
    <input type="text" placeholder="Post title" name="title" id="nime" bind:value="{postTitle}"><br>
    <label for="content">Post description:</label>
    <input type="text" placeholder="Post description" name="description" bind:value="{postDescription}"><br>
    <label for="content">Post content:</label>
    <input type="text" placeholder="Post content" name="content" bind:value="{postContent}"><br>
    <label for="tags">Tags (comma separated):</label>
    <input type="text" placeholder="code,svelte,motoko" name="tags" bind:value="{postTags}"><br>
    <label>
        <input type=checkbox bind:checked={postPublished}>
        Published
    </label>
    
    
    <button class="" on:click={createPost} disabled={loading}>
        {#if loading === true}
            Loading...
        {:else}
            Create post
        {/if}
    </button>
</div>