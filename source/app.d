import std.stdio;
import libutterfly;
import std.socket;

void main()
{
	writeln("Edit source/app.d to start your project.");

	/* TEST: Connect to server */
	ButterflyClient d = new ButterflyClient(parseAddress("0.0.0.0", 6969));

	/* TEST: Autheticate with server */
	d.authenticate("deavmi", "password");


	while(true)
	{
		
	}
	
}
