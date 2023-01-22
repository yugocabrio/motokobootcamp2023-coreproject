import Principal "mo:base/Principal";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import List "mo:base/List";
import Text "mo:base/Text";

actor {
    public type Tokens = {amount_e8s : Nat};

    public type Proposal = {
        id : Nat;
        voters : List.List<Principal>;
        state : ProposalState;
        timestamp : Int;
        proposer : Principal;
        votes_yes : Tokens;
        votes_no : Tokens;
        payload : ProposalPayload;
    };

    public type ProposalState = {
        #failed : Text;
        #open;
        #rejected;
        #accepted
    };

    public type ProposalPayload = {
        title : Text;
        button_text: Text;
    };

    public shared({caller}) func submit_proposal(this_payload : Text) : async {#Ok : Proposal; #Err : Text} {
        return #Err("Your principal is : " # Principal.toText(caller));
    };

    public shared({caller}) func vote(proposal_id : Int, yes_or_no : Bool) : async {#Ok : (Nat, Nat); #Err : Text} {
        return #Err("Not implemented yet");
    };

    public query func get_proposal(id : Int) : async ?Proposal {
        return null
    };
    
    public query func get_all_proposals() : async [(Int, Proposal)] {
        return []
    };
};