import std.stdio;
import libutterfly.client : ButterflyClient;
import libutterfly.exceptions : ButterflyException;
import std.socket;
import std.json;
import std.conv : to;


void testRegistration(ButterflyClient client, string username, string password)
{
	try
	{
		/* TEST: Register with server */
		client.register(username, password);

		writeln("<<< Registration OK>>>\n\nOK");
	}
	catch(ButterflyException e)
	{
		writeln("<<< Registration failed>>>\n\n"~e.toString());
	}
}

void testAuthentication(ButterflyClient client, string username, string password)
{
	try
	{
		/* TEST: Authenticate with server */
		client.authenticate("deavmi", "password");

		writeln("<<< Authentication OK>>>\n\nOK");
	}
	catch(ButterflyException e)
	{
		writeln("<<< Authentication failed>>>\n\n"~e.toString());
	}
}

void testFolderList(ButterflyClient client, string folder)
{
	try
	{
		/* TEST: Folder list */
		string[] mailIDs = client.listMail(folder);
		writeln("<<< Folder list OK>>>\n\n"~folder~": " ~to!(string)(mailIDs));
	}
	catch(ButterflyException e)
	{
		writeln("<<< Folder list failed>>>\n\n"~e.toString());
	}
	
}

void testStoreMessage(ButterflyClient client, string[] recipientsInput, string subject, string messageBody, string folder)
{
	JSONValue mailMessage;
	JSONValue[] recipients;
	foreach(string recipient; recipientsInput)
	{
		recipients ~= JSONValue(recipient);
	}
	
	mailMessage["recipients"] = recipients;
	mailMessage["subject"] = subject;
	mailMessage["body"] = messageBody;
	client.storeMail(folder, mailMessage);
}

void main()
{

	/* Create a new butterfly client */
	ButterflyClient clientServer1 = new ButterflyClient(parseAddress("10.0.0.9", 2222));

	/* Test account registration for account and password ("kwaranpyn", "password") */
	testRegistration(clientServer1, "kwaranpyn", "password");

	/* Test account registration for account and password ("deavmi", "password") */
	testRegistration(clientServer1, "deavmi", "password");

	/* Test account authentication for account and password ("deavmi", "password") */
	testAuthentication(clientServer1, "deavmi", "password");

	/* Test folder contents listing for deavmi's "Drafts" folder */
	testFolderList(clientServer1, "Drafts");

	/* Test storing a message to deavmi's "Drafts" folder */
	testStoreMessage(clientServer1, ["deavmi@10.0.0.9:2222"], "Hello there", "This is a body", "Drafts");

	/* Test folder contents listing for deavmi's "Drafts" folder */
	testFolderList(clientServer1, "Drafts");
	 
	// /* Create a new butterfly client */
	// ButterflyClient d = new ButterflyClient(parseAddress("10.0.0.9", 2223));

	// /* TEST: Register with server */
	// d.register("kwaranpyn", "password");

	// /* TEST: Connect to server */
	// d = new ButterflyClient(parseAddress("10.0.0.9", 2222));

	// /* TEST: Register with server */
	// d.register("deavmi", "password");

	// /* TEST: Listing of mail messages */
	// string[] mailIDs = d.listMail("Drafts");
	// writeln("Drafts: " ~to!(string)(mailIDs));

	// /* TEST: Storing of mail message */
	// JSONValue mailMessage;
	// JSONValue[] recipients;
	// recipients ~= JSONValue("deavmi@10.0.0.9:2222");
	// recipients ~= JSONValue("kwaranpyn@10.0.0.9:2223");
	// mailMessage["recipients"] = recipients;
	// mailMessage["subject"] = "Hello daar";
	// mailMessage["body"] = "Hi\noOOOOOOOOOOOo\n\nI'm never gonna find a wife";
	// d.storeMail("Drafts", mailMessage);

	// /* TEST: Sending of mail */
	// d.sendMail(mailMessage);
	// mailIDs = d.listMail("Inbox");
	// JSONValue mail = d.fetchMail("Inbox", mailIDs[0]);
	// writeln("Sent message: " ~ mail.toPrettyString);

	// /* TEST: Listing of mail */
	// mailIDs = d.listMail("Drafts");
	// writeln(mailIDs);

	// /* TEST: Fetch mail */
	// mail = d.fetchMail("Drafts", mailIDs[0]);
	// writeln(mail.toPrettyString);

	// /* TEST: Listing of folders */
	// string[] folderNames = d.listFolder("Drafts");
	// writeln(folderNames);

	// /* TEST: Adding a folder */
	// d.createFolder("Drafts/testFolder");

	// /* TEST: Listing of folders */
	// folderNames = d.listFolder("Drafts");
	// writeln(folderNames);

	// while(true)
	// {

	// }
	
}
