import Http "http";
import Text "mo:base/Text";

actor {
    public type HttpRequest = Http.HttpRequest;
    public type HttpResponse = Http.HttpResponse;

    stable var dao_message : Text = "Welcome page dao"; 

    public func change_text(printed_text : Text) : async Text {
        dao_message := printed_text;
        return dao_message;
    };

    public query func http_request(req : HttpRequest) : async HttpResponse {
        return({
            body = Text.encodeUtf8(dao_message);
            headers = [];
            status_code = 200;
            streaming_strategy = null;
        })
    };
};