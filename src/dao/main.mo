import Principal "mo:base/Principal";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import List "mo:base/List";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";

actor {
    public type Proposal = {
        id : Int;
        message : Text;
        proposer : Principal;
        votes_yes : Nat;
        votes_no : Nat;
    };

    stable var proposal_id : Int = 0;
    stable var proposal_list : [(Int, Proposal)] = [];
    let usernames = HashMap.fromIter<Int,Proposal>(proposal_list.vals(), 10, Int.equal, Int.hash);

    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {
        var suggestion : Proposal = {
            id = proposal_id;
            message = this_payload;
            proposer = caller;
            votes_yes = 0;
            votes_no = 0};
        usernames.put(proposal_id, suggestion);
        proposal_id += 1;    
        return #Ok(suggestion);
    };

    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool) : async {#Ok : (Nat, Nat); #Err : Text} {
        return #Err("Not implemented yet");
    };

    public query func get_proposal(id : Int) : async ?Proposal {
        // Debug.print(debug_show(Time.now())#" get  called   ");
        usernames.get(id); 
    };
    
    public query func get_all_proposals() : async [(Int, Proposal)] {
        let ret: [(Int, Proposal)] =Iter.toArray<(Int,Proposal)>(usernames.entries()); 
        return ret;
    };

    // webpageに反映させる
    let Webpage : actor { change_text : (Text) -> async () } = actor ("renrk-eyaaa-aaaaa-aaada-cai");

    public func webpage_test(message : Text) : async () {
        await Webpage.change_text(message);
    };
};