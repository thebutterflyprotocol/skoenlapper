import std.stdio;
import libutterfly;
import std.socket;
import std.json;

void main()
{

	ButterflyClient d = new ButterflyClient(parseAddress("0.0.0.0", 6969));

	/* TEST: Register with server */
	d.register("kwaranpyn", "password");

	/* TEST: Connect to server */
	d = new ButterflyClient(parseAddress("0.0.0.0", 6969));

	/* TEST: Register with server */
	d.register("deavmi", "password");

	/* TEST: Authenticate with server */
	d.authenticate("deavmi", "password");

	/* TEST: Listing of mail messages */
	string[] mailIDs = d.listMail("Drafts");
	writeln(mailIDs);

	/* TEST: Storing of mail message */
	JSONValue mailMessage;
	JSONValue[] recipients;
	recipients ~= JSONValue("deavmi@poes");
	recipients ~= JSONValue("kwaranpyn@10.1.0.7");
	mailMessage["recipients"] = recipients;
	d.storeMail("Drafts", mailMessage);

	/* TEST: Sending of mail */
	d.sendMail(mailMessage);

	/* TEST: Listing of mail */
	mailIDs = d.listMail("Drafts");
	writeln(mailIDs);


	while(true)
	{

	}
	
}
