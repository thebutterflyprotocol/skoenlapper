module skoenlapper.client;

import std.stdio;
import skoenlapper.configurator;
import libutterfly.client;
import gogga;
import std.conv : to;
import std.json;

/**
* Sends mail provided the subject, address(es) and body
*
* Assumes that the first active account is to be used (this can be changed)
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