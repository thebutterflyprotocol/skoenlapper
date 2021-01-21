module skoenlapper.client;

import std.stdio;

string composeMail()
{
    /* Read in from the tty */
	File tty;
	tty.open("/dev/stdin", "r");

	/* Body lines */
	string bodyLines;

	while(true)
	{
		/* Assume each line has a max, only read the max */
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
			break;
		}	

		/* Store the line */
		bodyLines ~= bodyLine;
	}

    return bodyLines;
}