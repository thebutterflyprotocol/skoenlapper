import std.stdio;
import libutterfly.client;
import std.socket;
import std.json;

void main()
{
	/* Create a new butterfly client */
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
	mailMessage["subject"] = "Hello daar";
	mailMessage["body"] = "Hi\noOOOOOOOOOOOo\n\nI'm never gonna find a wife";
	d.storeMail("Drafts", mailMessage);

	/* TEST: Sending of mail */
	d.sendMail(mailMessage);

	/* TEST: Listing of mail */
	mailIDs = d.listMail("Drafts");
	writeln(mailIDs);

	/* TEST: Fetch mail */
	JSONValue mail = d.fetchMail("Drafts", mailIDs[0]);
	writeln(mail.toPrettyString);

	/* TEST: Listing of folders */
	string[] folderNames = d.listFolder("Drafts");
	writeln(folderNames);

	/* TEST: Adding a folder */
	d.createFolder("Drafts/testFolder");

	/* TEST: Listing of folders */
	folderNames = d.listFolder("Drafts");
	writeln(folderNames);

	while(true)
	{

	}
	
}
