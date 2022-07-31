<script>

    import { useParams } from "svelte-navigator";
    import { onMount } from "svelte";
    import { useCanister, useConnect } from "@connect2ic/svelte"
    
    const [blog] = useCanister("blog")


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
<div>
    <label for="title">Post title:</label>
    <input type="text" name="title" id="nime" bind:value="{postTitle}"><br>
    <label for="content">Post description:</label>
    <input type="text" name="description" bind:value="{postDescription}"><br>
    <label for="content">Post content:</label>
    <input type="text" name="content" bind:value="{postContent}"><br>
    <label for="tags">Tags (comma separated):</label>
    <input type="text" name="tags" bind:value="{postTags}"><br>
    <label>
        <input type=checkbox bind:checked={postPublished}>
        Published
    </label><br>
    
    
    <button class="" on:click={updatePost} disabled={loading}>
        {#if loading === true}
            Loading...
        {:else}
            Update post
        {/if}
    </button>
</div>