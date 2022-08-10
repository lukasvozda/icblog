<script>
    import { marked } from 'marked';
    export let post;
    export let loading;
    export let submit_function;

</script>

<form>
    <label for="title">Title:</label>
    <input type="text" name="title" id="nime" bind:value="{post.title}" placeholder="Hellow World!" required><br>
    <label for="content">Description:</label>
    <input type="text" name="description" bind:value="{post.description}" maxlength="300"
        placeholder="Short description, max 300 characters." required><br>

    <label id="content-label" for="content">Content:</label>
    <!-- <div  id="editor" ></div> -->
    <textarea name="content" bind:value="{post.content}" rows="20" cols="50"
        placeholder="What are you going to write about?" required></textarea><br>
    {@html marked(post.content || "Loading")}
    <label for="tags">Tags (comma separated):</label>
    <input type="text" name="tags" bind:value="{post.tags}" placeholder="Motoko,Svelte"><br>
    <label>
        <input type=checkbox bind:checked={post.published}>
        Published
    </label><br>
    <button type="submit" class="submit" on:click={submit_function} disabled={loading}>
        {#if loading === true}
            Loading...
        {:else}
            Submit
        {/if}
    </button>
</form>

<style>
input[type=text], textarea {
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
#editor {
    margin-bottom: 10px;
    min-height: 300px;
}

.submit {
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

.submit:hover {
    text-decoration: underline;
}
</style>