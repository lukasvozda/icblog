import List "mo:base/List";
//import Option "mo:base/Option";
import Time "mo:base/Time";
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
//import Text "mo:base/Text";
import Iter "mo:base/Iter";
//import Prim "mo:prim";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor {

    type PostId = Nat;

    type Post = {
        title : Text;
        time_created: Time.Time;
        time_updated: Time.Time;
        content : Text;
        description : Text;
        published : Bool;
        author : Principal;
        tags : [Text]
    };

    type Error = {
      #PostNotFound;
      #UserNotAuthenticated;
      #EmptyTitle;
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
    
    public shared(msg) func create(post : {title : Text; description : Text; content : Text; published : Bool; tags : [Text]}): async Result.Result<(),Error> {
        // commented for local development
        // if(Principal.isAnonymous(msg.caller)){
        //     return #err(#UserNotAuthenticated);
        // };

        if(post.title == ""){
          return #err(#EmptyTitle)
        };

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
        return #ok(());
    };

    public query func get(id : PostId) : async Result.Result<Post, Error> {
        let post = blogposts.get(id);
        return Result.fromOption(post, #PostNotFound);
    };


    public shared(msg) func update(id : PostId, post : {title : Text; description : Text; content : Text; published : Bool; tags : [Text]}) : async Result.Result<(),Error> {
        // commented for local development
        // if(Principal.isAnonymous(msg.caller)){
        //     return #err(#UserNotAuthenticated);
        // };

        if(post.title == ""){
          return #err(#EmptyTitle)
        };
                
        let result = blogposts.get(id);

        switch (result){
            case null {
                return #err(#PostNotFound);
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
        return #ok(());
    };



    public shared(msg) func  delete(id : PostId) : async Result.Result<(),Error> {
      if(Principal.isAnonymous(msg.caller)){
        return #err(#UserNotAuthenticated);
      } else {
        blogposts.delete(id);
        return #ok(());
      }
    };

    public query func get_all_posts() : async List.List<Post> {
        let iter = blogposts.entries();
        var post_list : List.List<Post> = List.nil();

        for ((postNat, post) in iter){
            //Prim.debugPrint(debug_show(post_list));
            post_list := List.push<Post>(post, post_list);
        };
        return post_list;
    };

    // do not use – making nested arrays
    public query func list(): async  List.List<(PostId,Post)> {
        return Iter.toList(blogposts.entries());
    };

    public query func list_all(): async [(PostId, Post)] {
        return Iter.toArray(blogposts.entries());
    };

    func published((id : PostId, p : Post)) : Bool {
      return p.published
    };

    public query func list_published(): async [(PostId, Post)] {
        return Array.filter(Iter.toArray(blogposts.entries()), published);
    };  
};