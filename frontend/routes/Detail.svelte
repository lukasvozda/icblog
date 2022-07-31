<script>
    import { useParams } from "svelte-navigator";
    import { useCanister } from "@connect2ic/svelte"
    import { onMount } from "svelte";

    let loading = true

    const [blog] = useCanister("blog", { mode: "anonymous" })

    const params = useParams();

    let postId = parseInt($params.id);
    console.log($params.id)

    let post = {}

    const get_post = async () => {
        loading = true
        console.log("Gettin post: " + postId)
        const res = await $blog.get(postId)
        console.log(res)
        post = res[0]
        if (post) {
            console.log(post)
        } else {
            console.log("Post not found")
            post = {
                title: "<Post not found>",
                content: "<No content>"
            }
        }
        
        loading = false
        return post
    }

    function getDate(timestamp) {
        var converted = Number(timestamp) / 1000000;
        var date = new Date(converted);
        var year = date.getFullYear();
        var month = ("0" + (date.getMonth() + 1)).substr(-2);
        var day = ("0" + date.getDate()).substr(-2);


        return year + "-" + month + "-" + day ;
    }

    onMount(get_post)

</script>

<h1>{post.title || 'Loading'}</h1>
<a href="/update/{postId}">Edit post</a>

<div class="posts">
    <!-- <li>{post[0]} - {post[1].title} <button on:click={() => delete_post(post[0])} class="x">x</button></li> -->
    <div class="post">
        <div class="author">Written by: {post.author}  </div>
        <div class="post-description">
            {post.content}
        </div>
        <div class="date">Last updated: {getDate(post.time_updated)}</div>
        <div class="date">Date created: {getDate(post.time_created)}</div>
    </div>
    <div class="tags">
        {#if post.tags}
            {#each post.tags as tag}
                <span class="tag">#{tag}</span>
            {/each}
        {/if}
    </div>
</div>    
