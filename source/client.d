module skoenlapper.client;

import std.stdio;
import skoenlapper.configurator;
import libutterfly.client;
import gogga;
import std.conv : to;
import std.json;
import std.file : exists, mkdir;
import core.thread : Thread, dur;

/**
* Runs the mail daemon which creates a local directory
* structure mirroring that of the server's mailbox,
* filling each folder and sub-folder with ist respective
* contents and watching for any new mail that comes in
*
* Assumes that the first active account is to be used (this can be changed)addresses
*/
void mailDaemon(ulong accountIndex = 0)
{
    /* Read in configurstion */
    Configuration configuration = new Configuration(getConfiguration());

    /* Get the account to be used (TODO: Bounds check) */
    Account chosenAccount = configuration.getAccount(accountIndex);

    /* Authenticate a new session (TODO: Error handling in library and then catch here) */
    gprintln("Opening connection to "~to!(string)(chosenAccount.getServer()));
    ButterflyClient client = new ButterflyClient(chosenAccount.getServer());

    /* Authenticate (TODO: Error) */
    gprintln("Authenticating with server...");
    client.authenticate(chosenAccount.getUsername(), chosenAccount.getPassword());

    string[] root = client.listFolder("/");
    gprintln("Found folders: "~to!(string)(root));

    /* Check if the directory for this account exists (if not then create it) */
    if(!exists(chosenAccount.getMailbox()))
    {
        mkdir(chosenAccount.getMailbox());
    }

    /* Preiodically check for new mail */
    while(true)
    {
        /* Create folder structure every now and then (skipping already present stuff) */
        grpintln("Starting mail check cycle...");
        createFolderStructures(chosenAccount.getMailbox(), "/", client);
        Thread.sleep(dur!("seconds")(5));
        grpintln("Mail check cycle completed");
    }
}

/**
* Creates the folder structure in the mailbox for the 
* specified account
*/
void createFolderStructures(string mailboxDirectory, string currentFolder, ButterflyClient client)
{
    /* Get all folders */
    string[] folders = client.listFolder(currentFolder);

    /* Loop through each directory of the current `root` */
    foreach(string directory; folders)
    {
        /* Create the directory */
        gprintln("Checking for local directory for remote directory '"~directory~"'...");
        if(!exists(mailboxDirectory~currentFolder~"/"~directory))
        {
            gprintln("Creating local directory for remote directory '"~directory~"'...");
            mkdir(mailboxDirectory~currentFolder~"/"~directory);
        }

        /* List all mail in the current folder */
        string[] mailIDs = client.listMail(currentFolder~"/"~directory);
        foreach(string mailID; mailIDs)
        {
            /* If the mail exists then skip it */
            if(exists(mailboxDirectory~currentFolder~"/"~directory~"/"~mailID))
            {
                continue;
            }

            /* Fetch the mail message */
            gprintln("Fetching mail message '"~mailID~"'...");
            JSONValue mail = client.fetchMail(currentFolder~"/"~directory, mailID);

            /* Store mail message */
            File file;
            file.open(mailboxDirectory~currentFolder~"/"~directory~"/"~mailID, "wb");
            file.rawWrite(cast(byte[])to!(string)(mail));
            file.close();
        }

        /* Do the same on the current folder */
        createFolderStructures(mailboxDirectory, currentFolder~"/"~directory, client);
    }
}

/**
* Sends mail provided the subject, address(es) and body
*
* Assumes that the first active account is to be used (this can be changed)addresses
*/
void sendMail(string subject, string[] addresses, string bodyText, ulong accountIndex = 0)
{
    /* Read in configurstion */
    Configuration configuration = new Configuration(getConfiguration());

    /* Get the account to be used (TODO: Bounds check) */
    Account chosenAccount = configuration.getAccount(accountIndex);

    /* Authenticate a new session (TODO: Error handling in library and then catch here) */
    gprintln("Opening connection to "~to!(string)(chosenAccount.getServer()));
    ButterflyClient client = new ButterflyClient(chosenAccount.getServer());

    /* Authenticate (TODO: Error) */
    gprintln("Authenticating with server...");
    client.authenticate(chosenAccount.getUsername(), chosenAccount.getPassword());

    /* Construct the mail */
    JSONValue mailMessage;
    mailMessage["recipients"] = parseJSON(to!(string)(addresses));
    mailMessage["subject"] = subject;
    mailMessage["body"] = bodyText;

    /* Send the mail */
    gprintln("Sending mail...");
    client.sendMail(mailMessage);
    gprintln("Mail sent!");
}

string composeMail()
{
    /* Read in from the tty */
	File tty;
	tty.open("/dev/stdin", "rb");

	/* Body lines */
	string bodyLines;

	while(true)
	{
		/* Read in 30-bute strides */
		byte[] bodyLine;
		bodyLine.length = 30;

		/* Read a line */
		bodyLine = tty.rawRead(bodyLine);
				
		/**
		* Read returns then we are done reading, either the bodyLine.length
		* is non-zero but if it is zero then nothing was read (hence an EOF)
		* signal
		*/
		if(bodyLine.length == 0)
		{
            /* Close the file and stop loop */
            tty.close();
			break;
		}	

		/* Store the line */
		bodyLines ~= bodyLine;
	}

    return bodyLines;
}