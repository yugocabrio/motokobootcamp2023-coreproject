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

    // public type Account = { owner : Principal; };
    // let Ledger : actor = {checkAccountBalance : (Account) -> async Nat} = actor("dg2ce-tqaaa-aaaah-abz6q-cai");

    //let Ledger : actor { 
    //    checkAccountBalance: (Principal) -> async Nat;
    //} = actor("r7inp-6aaaa-aaaaa-aaabq-cai");

    //public func get_mb_balance(id : Principal) : async Nat {
    //    return await Ledger.checkAccountBalance(id);
    //};
    // 100以上超えた時の処理
    // MBtokenが1以上持っているか
    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool, vote_power : Nat) : async {#Ok : (Nat, Nat); #Err : Text} {
        var pr: ?Proposal = usernames.get(proposal_id);
        switch(pr) {
            case(null) {
                return #Err("problem");
            };
            case(?pr) {
                var vote_yes : Nat = pr.votes_yes;
                var vote_no : Nat = pr.votes_no;
                if (yes_or_no) {
                    vote_yes := vote_power;
                } else {
                    vote_no := vote_power;
                };
                var suggestion : Proposal = {id=pr.id; message=pr.message; proposer=pr.proposer; votes_yes= vote_yes; votes_no=vote_no };
                usernames.put(pr.id, suggestion); 
                return #Ok(suggestion.votes_yes, suggestion.votes_no);  
                // ここで100処理を書いていく
            };

        };
    };


    public query func get_proposal(id : Int) : async ?Proposal {
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