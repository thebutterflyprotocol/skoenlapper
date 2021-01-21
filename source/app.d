import std.stdio;
import libutterfly.client : ButterflyClient;
import libutterfly.exceptions : ButterflyException;
import std.socket;
import std.json;
import std.conv : to;
import std.string : cmp, split;
import gogga;
import std.file;
import std.conv : to;
import skoenlapper.commandline;
import skoenlapper.client;

void main(string[] args)
{
	if(args.length >= 2)
	{
		/* Check for `--help` */
		if(cmp(args[1], "help") == 0)
		{
			showHelp();
		}
		/* If `new` */
		else if(cmp(args[1], "new") == 0)
		{
			/* Parse the command-line arguments */
			MailData mailFields = newMailParse(args[1..args.length]);

			/**
			* Check if a subject was filled (TODO: A blank can be
			* parsed on the command-line ofc as an empty string, we don't
			* allow it but we should)
			*/
			if(cmp(mailFields.subject, "") == 0)
			{
				gprintln("No subject was provided");
				return;
			}

			/* Check if the to was filled */
			if(mailFields.to.length == 0)
			{
				gprintln("No to was provided");
				return;
			}

			/* Read the mail in from the tty */
			string bodyLines = composeMail();

		
			writeln("Mail: "~to!(string)(cast(byte[])bodyLines));


			sendMail(mailFields.subject, mailFields.to, bodyLines);
		}
		/* Unknown command */
		else
		{
			writeln("Unknown command \""~args[1]~"\"");
		}
	}
}

void testRegistration(ButterflyClient client, string username, string password)
{
	try
	{
		/* TEST: Register with server */
		client.register(username, password);

		writeln("<<< Registration OK >>>\n\nOK");
	}
	catch(ButterflyException e)
	{
		writeln("<<< Registration failed >>>\n\n"~e.toString());
	}
}

void testAuthentication(ButterflyClient client, string username, string password)
{
	try
	{
		/* TEST: Authenticate with server */
		client.authenticate("deavmi", "password");

		writeln("<<< Authentication OK >>>\n\nOK");
	}
	catch(ButterflyException e)
	{
		writeln("<<< Authentication failed >>>\n\n"~e.toString());
	}
}

void testMailList(ButterflyClient client, string folder)
{
	try
	{
		/* TEST: Mail list */
		string[] mailIDs = client.listMail(folder);
		writeln("<<< Mail list OK >>>\n\n"~folder~": " ~to!(string)(mailIDs));
	}
	catch(ButterflyException e)
	{
		writeln("<<< Mail list failed >>>\n\n"~e.toString());
	}
}

void testFolderList(ButterflyClient client, string folder)
{
	try
	{
		/* TEST: Folder list */
		string[] folders = client.listFolder(folder);
		writeln("<<< Folder list OK >>>\n\nFolders: "~to!(string)(folders));
	}
	catch(ButterflyException e)
	{
		writeln("<<< Folder list failed >>>\n\n"~e.toString());
	}
}



void testStoreMessage(ButterflyClient client, string[] recipientsInput, string subject, string messageBody, string folder)
{
	try
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
		string mailID = client.storeMail(folder, mailMessage); /* TODO: This is not updated in libutterfly to return the mailID */

		writeln("<<< Message store OK >>>\n\nMail stored as: " ~mailID);
	}
	catch(ButterflyException e)
	{
		writeln("<<< Message store failed >>>\n\n"~e.toString());
	}	
}

void testFolderCreate(ButterflyClient client, string folderPath)
{
	try
	{
		client.createFolder(folderPath);

		writeln("<<< Folder create OK >>>\n\n");
	}
	catch(ButterflyException e)
	{
		writeln("<<< Folder create failed >>>\n\n"~e.toString());
	}
}

void mainTest()
{
	/* Create a new butterfly client */
	ButterflyClient clientServer1 = new ButterflyClient(parseAddress("10.0.0.9", 2222));

	/* Create a new butterfly client */
	ButterflyClient clientServer2 = new ButterflyClient(parseAddress("10.0.0.9", 2223));

	/* Create a new butterfly client */
	ButterflyClient clientServer3 = new ButterflyClient(parseAddress("10.0.0.7", 2222));

	/* Create a new butterfly client */
//	ButterflyClient clientServer4 = new ButterflyClient(parseAddress("161.35.91.250", 6969));


	/* Test account registration for account and password ("adriaan", "password") */
//	testRegistration(clientServer4, "adriaan", "password");

	/* Test account registration for account and password ("kwaranpyn", "password") */
	testRegistration(clientServer2, "kwaranpyn", "password");

	/* Test account registration for account and password ("deavmi", "password") */
	testRegistration(clientServer1, "deavmi", "password");

	/* Test account registration for account and password ("kwaranpyn", "password") */
	testRegistration(clientServer3, "kwaranpyn", "password");


	/* Test account authentication for account and password ("deavmi", "password") */
	testAuthentication(clientServer1, "deavmi", "password");


	/* Test folder contents listing for deavmi's "Inbod" folder */
	testMailList(clientServer1, "Inbox");


	/* Test folder contents listing for deavmi's "Drafts" folder */
	testMailList(clientServer1, "Drafts");

	/* Test storing a message to deavmi's "Drafts" folder */
	testStoreMessage(clientServer1, ["deavmi@10.0.0.9:2222"], "Hello dthere", "This is a body", "Drafts");

	/* Test folder contents listing for deavmi's "Drafts" folder */
	testMailList(clientServer1, "Drafts");


	/* Listing of folders in folder "Drafts" */
	testFolderList(clientServer1, "Drafts");
	
	/* Test adding a folder in the already existing "Drafts" folder */
	testFolderCreate(clientServer1, "Drafts/testFolder");

	/* Listing of folders in folder "Drafts" */
	testFolderList(clientServer1, "Drafts");


	/* Listing of mail in folder "Sent" */
	testMailList(clientServer1, "Sent");

	/* Send a mail message to myself */
	JSONValue mailMessage;
	JSONValue[] recipients;
	recipients ~= JSONValue("deavmi@10.0.0.9:2222");
	// recipients ~= JSONValue("kwaranpyn@10.0.0.9:2223");
	mailMessage["recipients"] = recipients;
	mailMessage["subject"] = "Test subject";
	mailMessage["body"] = "Mail to myself";

	// /* TEST: Sending of mail */
	clientServer1.sendMail(mailMessage);


	/* Listing of mail in folder "Sent" */
	testMailList(clientServer1, "Sent");





	/* Listing of mail in folder "Sent" */
	testMailList(clientServer1, "Sent");

	/* Send a mail message to myself */
	recipients = [];
	recipients ~= JSONValue("deavmi@10.0.0.9:2222");
	recipients ~= JSONValue("kwaranpyn@10.0.0.9:2223");
	recipients ~= JSONValue("kwaranpyn@10.0.0.7:2222");
	mailMessage["recipients"] = recipients;
	mailMessage["subject"] = "Test subject";
	mailMessage["body"] = "Mail to myself";

	// /* TEST: Sending of mail */
	clientServer1.sendMail(mailMessage);


	/* Listing of mail in folder "Sent" */
	testMailList(clientServer1, "Sent");



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