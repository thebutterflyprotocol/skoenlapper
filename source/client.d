module skoenlapper.client;

import std.stdio;
import skoenlapper.configurator;

/**
* Sends mail provided the subject, address(es) and body
*
* Assumes that the first active account is to be used (this can be changed)
*/
void sendMail(string subject, string[] addresses, string bodyText, ulong accountIndex = 0)
{
    /* Read in configurstion */
    Configuration configuration;
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
		/* Assume each line has a max, only read the max (which is now 30 bytes) */
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