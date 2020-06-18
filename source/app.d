import std.stdio;
import libutterfly;
import std.socket;

void main()
{
	/* TEST: Connect to server */
	ButterflyClient d = new ButterflyClient(parseAddress("0.0.0.0", 6969));

	/* TEST: Register with server */
	d.register("deavmi", "password");

	/* TEST: Autheticate with server */
	d.authenticate("deavmi", "password");


	while(true)
	{

	}
	
}
