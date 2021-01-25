module skoenlapper.commandline;

import std.stdio;
import std.json;
import std.conv : to;
import std.string : cmp, split;
import gogga;
import std.file;
import std.conv : to;
import std.socket : Address, parseAddress;

string VERSION = "vPOES.POES.POES";

void showHelp()
{
	write("skoenlapper "~VERSION~"\n\n");
	writeln("help\t\tShows this screen");
	writeln("new -t [address, address, ...] -s [subject]\t\tSend a new mail");
}

/* Struct for mail data */
struct MailData
{
    string configFile;
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
        /* Check for config (-c [file]) */
        else if(cmp(args[pos], "-c") == 0)
        {
            /* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the to configFile */
			mailFields.configFile = args[pos+1];

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

/* Struct for registration */
struct RegistrationData
{
    string username;
    string password;
    Address server;
}

RegistrationData register(string[] args)
{
	/* The registration data */
	RegistrationData registrationData;

	ulong pos = 0;
	while(pos < args.length)
	{
		/* Check for username (-u [username])*/
		if(cmp(args[pos], "-u") == 0)
		{
			/* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the username */
			registrationData.username = args[pos+1];

			/* Skip to next argument */
			pos+=2;
		}
		/* Check for to (-p [password]) */
		else if(cmp(args[pos], "-p") == 0)
		{
			/* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the to password */
			registrationData.password = args[pos+1];

			/* Skip to next argument */
			pos+=2;
		}
        /* Check for server (-s [address:port]) */
        else if(cmp(args[pos], "-s") == 0)
        {
            /* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the server address */
            string tuple = args[pos+1];
			registrationData.server = parseAddress(split(tuple, ":")[0], to!(ushort)(split(tuple, ":")[1]));

			/* Skip to next argument */
			pos+=2;
        }
		else
		{
			/* Skip to next argument */
			pos++;
		}
	}

	return registrationData;
}


/* Struct for mail view */
struct MailView
{
    string configFile;
	string account;
	string[] paths;
}

MailView newMailView(string[] args)
{
	/* The mail view */
	MailView mailView;

	ulong pos = 0;
	while(pos < args.length)
	{
		/* Check for to (-m [mailPath,mailPath,mailPath]) */
		if(cmp(args[pos], "-m") == 0)
		{
			/* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the to mail path(s) */
			mailView.paths = split(args[pos+1], ",");

			/* Skip to next argument */
			pos+=2;
		}
		/* Check for config (-c [file]) */
        else if(cmp(args[pos], "-c") == 0)
        {
            /* Make sure we are not overruning buffer */
			if(pos+1 == args.length)
			{
				break;
			}
			
			/* Get the to configFile */
			mailView.configFile = args[pos+1];

			/* Skip to next argument */
			pos+=2;
        }
		else
		{
			/* Skip to next argument */
			pos++;
		}
	}

	return mailView;
}