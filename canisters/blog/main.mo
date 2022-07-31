import List "mo:base/List";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Iter "mo:base/Iter";


actor {

    public type PostId = Nat;
    private type Created = Time.Time;
    private type Updated = Time.Time;

    public type Post = {
        title : Text;
        time_created: Created;
        time_updated: Updated;
        content : Text;
        description : Text;
        published : Bool;
        author : Principal;
        tags : [Text]
    };

        
    private stable var next : PostId = 1;
    private stable var stableposts : [(PostId, Post)] = [];
        
    let eq: (Nat, Nat) -> Bool = func(x, y) { x == y };
    private var blogposts = Map.HashMap<PostId, Post>(0, eq, Hash.hash);
    //private var stablemap = Map.HashMap<PostId, Post>(entries.entries(), eq, Hash.hash);


    public shared(msg) func is_logged() : async Principal {
        return msg.caller;
    };

    system func preupgrade() {
        stableposts := Iter.toArray(blogposts.entries());
    };

    system func postupgrade() {
        blogposts := Map.fromIter<PostId, Post>(stableposts.vals(), 10, eq, Hash.hash);
        stableposts := [];
    };
    
    public shared(msg) func create(post : {title : Text; description : Text; content : Text; published : Bool; tags : [Text]}): async PostId {
        let postId = next;
        next += 1;

        let blogpost: Post = {
            time_created = Time.now();
            time_updated = Time.now();
            title = post.title;
            description = post.description;
            content = post.content;
            published = post.published;
            author = msg.caller;
            tags = post.tags;
        };
        
        blogposts.put(postId, blogpost);
        return postId;
    };

    
    public shared(msg) func create_test(): async PostId {
        let postId = 0;
        let blogpost: Post = {
            time_created = Time.now();
            time_updated = Time.now();
            title = "Testovací post";
            content = "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. We swallow it too fast, we choke. We get some in our lungs, we drown. However unreal it may seem, we are connected, you and I. We're on the same curve, just on opposite ends.";
            description = "Your bones don't break, mine do. That's clear. Your cells react to bacteria and viruses differently than mine. You don't get sick, I do. That's also clear. But for some reason, you and I react the exact same way to water. ";
            published = true;
            author = msg.caller;
            tags = ["Programming", "Svelte"];
        };
        
        blogposts.put(postId, blogpost);
        
        return postId;
    };

    public query func get(id : PostId) : async ?Post {
        blogposts.get(id)
    };


    public shared(msg) func update(id : PostId, post : {title : Text; description : Text; content : Text; published : Bool; tags : [Text]}) : async Bool {
        let result = blogposts.get(id);

        switch (result){
            case null {
                return false;
            };
            case (? v){
                let blogpost : Post = {
                    time_created = v.time_created;
                    time_updated = Time.now();
                    title = post.title;
                    content = post.content;
                    description = post.description;
                    published = post.published;
                    author = v.author;
                    tags = post.tags;
                };
                blogposts.put(id, blogpost);
            };
        };
        return true;
    };



    public func delete(id : PostId) : async Bool {
        blogposts.delete(id);
        return true;
    };

    public query func get_all_posts() : async List.List<Post> {
        let iter = blogposts.entries();
        var post_list : List.List<Post> = List.nil();

        for ((postNat, post) in iter){
            post_list := List.push<Post>(post, post_list);
        };
        return post_list;
    };

    public query func list(): async  List.List<(PostId,Post)> {
        // returning records instead of list
        return Iter.toList(blogposts.entries());
    };

    public query func list_array(): async [(PostId, Post)] {
        return Iter.toArray(blogposts.entries());
    };

    
};
