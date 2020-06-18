import std.stdio;
import libutterfly;
import std.socket;
import std.json;

void main()
{
	/* TEST: Connect to server */
	ButterflyClient d = new ButterflyClient(parseAddress("0.0.0.0", 6969));

	/* TEST: Register with server */
	d.register("deavmi", "password");

	/* TEST: Authenticate with server */
	d.authenticate("deavmi", "password");

	/* TEST: Storing of mail message */
	JSONValue mailMessage;
	JSONValue[] recipients;
	recipients ~= JSONValue("me");
	mailMessage["recipients"] = recipients;
	d.storeMail("Inbox", mailMessage);

	while(true)
	{

	}
	
}
