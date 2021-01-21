module skoenlapper.commandline;

import std.stdio;
import std.json;
import std.conv : to;
import std.string : cmp, split;
import gogga;
import std.file;
import std.conv : to;

string VERSION = "vPOES.POES.POES";

void showHelp()
{
	write("skoenlapper "~VERSION~"\n\n");
	writeln("help\t\tShows this screen");
	writeln("new\t\tSend a new mail");
}

/* Struct for mail data */
struct MailData
{
	string subject;
	string[] to;
}

MailData newMailParse(string[] args)
{
	/* The mail data */
	MailData mailFields;

	/* The subject line */
	string subject;

	/* The to addresses */
	string[] to;

	ulong pos = 0;
	while(pos < args.length)
	{
		/* Check for subject (-s [subject])*/
		if(cmp(args[pos], "-s") == 0)
		{
			/* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the subject */
			mailFields.subject = args[pos+1];

			/* Skip to next argument */
			pos+=2;
		}
		/* Check for to (-t [address,address,address]) */
		else if(cmp(args[pos], "-t") == 0)
		{
			/* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the to address(es) */
			mailFields.to = split(args[pos+1], ",");

			/* Skip to next argument */
			pos+=2;
		}
		else
		{
			/* Skip to next argument */
			pos++;
		}
	}

	return mailFields;
}