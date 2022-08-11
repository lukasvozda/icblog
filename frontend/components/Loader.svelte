<script>
    import { fade } from 'svelte/transition';
    import spinner from "../assets/spinner.svg"
    export let loading 

</script>
{#if loading}
    <div class="loader" transition:fade="{{deoay: 200, duration: 500}}">
    <img src="{spinner}" alt="loading">
    </div>
{/if}


<style>
    .loader {
        position: absolute;
        background-color: rgba(255, 255, 255, 0.8);
        /*dim the background*/
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        color: black;
        text-align: center;
        transition: all 0.4s ease;
    }

    .loader img {
        position: absolute;
        top: 50%;
        left: 50%;
        -webkit-transform: translate(-50%, -50%);
        transform: translate(-50%, -50%);
    }
</style>