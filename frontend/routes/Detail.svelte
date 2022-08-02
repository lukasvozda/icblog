<script>
    import { useParams } from "svelte-navigator";
    import { useConnect, useCanister } from "@connect2ic/svelte"
    import { onMount } from "svelte";

    let loading = true

    const [blog] = useCanister("blog", { mode: "anonymous" })

    const { isConnected } = useConnect()

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
<div class="author">Written by: {post.author}  </div>
<div class="date">Last updated: {getDate(post.time_updated)}</div>
<div class="date">Date created: {getDate(post.time_created)}</div>
<div class="tags">
    {#if post.tags}
        {#each post.tags as tag}
            <span class="tag">#{tag}</span>
        {/each}
    {/if}
</div>
{#if $isConnected}
    <a href="/update/{postId}" class="edit">Edit</a>
    <a href="/delete/{postId}" class="delete">Delete</a>
{:else}
    <div>Connect your wallet to edit or delete post.</div>
{/if}
<div class="posts">
    <!-- <li>{post[0]} - {post[1].title} <button on:click={() => delete_post(post[0])} class="x">x</button></li> -->
    <div class="post">
        
        <div class="post-description">
            {post.content}
        </div>
    </div>

</div>    

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
            white-space: pre-wrap;

        }

        .author,
        .date {
            font-size: 80%;
            color: gray;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .tags {
            font-size: 80%;
            margin-bottom: 30px;
        }

        .tag {
            margin-right: 5px;
            color: gray;
        }

        .edit,
        .delete {
            color: #a02480;
            padding: 10px 20px;
            text-decoration: none;
            margin: 5px;
            border-radius: 40px;
        }

        .edit:hover,
        .delete:hover {
            text-decoration: underline;
        }

        .edit {
            background-color: aquamarine;
        }

        .delete {
            background-color: burlywood;
        }
</style>