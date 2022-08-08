<script>
    import { useCanister, useConnect } from "@connect2ic/svelte"
    import Loader from "../components/Loader.svelte"
    import Form from "../components/Form.svelte"

    //const [blog] = useCanister("blog")
    const [blog] = useCanister("blog", { mode: "anonymous" })

    let loading = false
    let status = ""
    let message = ""
    let post = {
        title: "",
        content: "",
        description: "",
        published: false,
        tags: ""
    }

    
    const createPost = async () => {
        loading = true
        console.log(post.tags)
        post.tags = post.tags.replace(" ", "").split(",")
        
        const res = await $blog.create(post)
        console.log(res)
        if("ok" in res){
            message = "Post was successfully created!"
            status = "ok"
        } else {
            message = "Post couldn't be created: " + Object.keys(res.err)[0]
            status = "err"
            
        }
        post.tags = post.tags.join(",")
        loading = false
    } 
</script>


<h1>New blog post</h1>
<div class="back">
    <a href="/">Go back</a>
</div> 
<div class="posts">
    <div class="post">
        <div>
            <Form loading={loading} post={post} submit_function={createPost}/>
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

}
.post {
    text-align: left;
    display: block;

}
</style>